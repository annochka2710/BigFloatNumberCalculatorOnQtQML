#include "calculator.h"
#include <QStack>
#include <QChar>
#include <cmath>
#include <sstream>
#include <iomanip>
#include <QRegularExpression>

Calculator::Calculator(QObject *parent) : QObject(parent), display("0"), error(false) {}

void Calculator::append(const QString &num){
    if(error || display.length() > 25) return;

    if (secretMode) {
        secret += num;
        if (secret == "123") emit secretMenu();
    }

    if(display == "0" && num != ".") {
        display = num;
    } else {
        QChar lastChar = display.isEmpty() ? QChar() : display[display.length() - 1];
        if (lastChar == ')')
            display += "*" + num;
        else
            display += num;
    }
    emit displayChanged(display);
}

void Calculator::setOper(const QString& oper){
    if (error || display.length() > 25) return;
    if(display == "0" && oper != "-")
        display = "0" + oper;
    else {
        QChar lastChar = display.isEmpty() ? QChar() : display[display.length() - 1];
        if (lastChar == '+' || lastChar == '-' || lastChar == '*' || lastChar == '/' || lastChar == '%')
            display.chop(1);
        if (oper == "-" && (lastChar == '+' || lastChar == '*' || lastChar == '/' || lastChar == '%' || lastChar == '('))
            display += "(-";
        else display += oper;
    }
    emit displayChanged(display);
}

void Calculator::calcul(){
    if(error || display.isEmpty()) return;
    if (!isValidExpr(display)) {
        error = true;
        result = "Ошибка: несбалансированные скобки";
        emit errorHappened(result);
        emit resultChanged(result);
        return;
    }

    try{
        BigFloat res = evaluateExpr(display);
        updateResult(res);
        emit displayChanged(display);
    }
    catch(const QString &errorMsg){
        error = true;
        result = "Ошибка: " + errorMsg;
        emit errorHappened(errorMsg);
        emit resultChanged(result);
    }
}

void Calculator::clear(){
    display = "0";
    result = "0";
    error = false;
    emit displayChanged(display);
    emit resultChanged(result);
}

void Calculator::addDecimal(){
    if(error) return;
    if (!display.contains('.')) {
        if (display == "0" || display == "") {
            display = "0.";
        } else {
            display += ".";
        }
        emit displayChanged(display);
    }
}

void Calculator::changeSign() {
    if (error || display.isEmpty() || display == "0") return;
    if (display.startsWith("(-") && display.endsWith(')')) {
        display = display.mid(2, display.length() - 3);
    } else {
        display = "(-" + display + ")";
    }

    emit displayChanged(display);
}

void Calculator::addBracket(const QString& bracket) {
    if (error) return;

    if (bracket == "(") {
        if (display == "0" || display.isEmpty()) {
            display = "(";
        } else {
            QChar lastChar = display.isEmpty() ? QChar() : display[display.length() - 1];
            if (lastChar.isDigit() || lastChar == ')') display += "*(";
            else if (lastChar == '.' || lastChar == '(') display += "(";
            else display += "(";
        }
    } else if (bracket == ")") {
        int openBrackets = display.count('(');
        int closeBrackets = display.count(')');

        if (openBrackets > closeBrackets) {
            QChar lastChar = display.isEmpty() ? QChar() : display[display.length() - 1];
            if (lastChar.isDigit() || lastChar == ')' || lastChar == '.') {
                display += ")";
            }
        }
    }
    emit displayChanged(display);
}

void Calculator::backspace() {
    if (error) return;
    if (display.length() > 1) {
        display.chop(1);
    } else {
        display = "0";
    }
    emit displayChanged(display);
}

void Calculator::calcPercent() {
    if (error) return;
    try {
        BigFloat value = evaluateExpr(display);
        value = value / 100.0;
        display = formatNumber(value);
        emit displayChanged(display);
        updateResult(value);
    }
    catch(const QString &errorMsg) {
        error = true;
        result = "Ошибка: " + errorMsg;
        emit errorHappened(errorMsg);
        emit resultChanged(result);
    }
}

void Calculator::setSecretMode(bool val) {
    secretMode = val;
    if (val == false) secret = "";
}

QString Calculator::getRes() const{
    return result;
}

QString Calculator::getMathExpr() const{
    return display;
}

//--------------------private--------------------

Calculator::BigFloat Calculator::stringToBigFloat(const QString& str) {
    std::string stdStr = str.toStdString();
    try {
        return BigFloat(stdStr);
    } catch (const std::exception& e) {
        throw QString("Некорректное число: " + str);
    }
}

QString Calculator::bigFloatToString(const BigFloat& value) {
    std::stringstream ss;
    ss << std::setprecision(25) << value;

    std::string result = ss.str();

    // Убираем лишние нули в дробной части
    size_t dotPos = result.find('.');
    if (dotPos != std::string::npos) {
        // Удаляем trailing zeros
        result = result.substr(0, result.find_last_not_of('0') + 1);
        if (result.back() == '.') {
            result.pop_back();
        }
    }

    return QString::fromStdString(result);
}

void Calculator::updateResult(const BigFloat& res){
    result = bigFloatToString(res);
    emit resultChanged(result);
}

Calculator::BigFloat Calculator::evaluateExpr(const QString& expr){
    QStack<BigFloat> numbers;
    QStack<QChar> operators;

    int i = 0;
    int len = expr.length();

    auto applyOperator = [&]() {
        if (operators.isEmpty() || numbers.size() < 2) return;

        QChar op = operators.pop();
        BigFloat b = numbers.pop();
        BigFloat a = numbers.pop();
        BigFloat result = 0.0;

        switch (op.toLatin1()) {
        case '+': result = a + b; break;
        case '-': result = a - b; break;
        case '*': result = a * b; break;
        case '/':
            if (b == 0) throw QString("Деление на ноль");
            result = a / b;
            break;
        case '%':
            if (b == 0) throw QString("Деление на ноль");
            result = fmod(a, b);
            if (result < 0) result += b; // Нормализация остатка
            break;
        }
        numbers.push(result);
    };

    auto precedence = [](QChar op) {
        if (op == '+' || op == '-') return 1;
        if (op == '*' || op == '/' || op == '%') return 2;
        return 0;
    };

    while (i < len) {
        QChar ch = expr[i];
        if (ch.isSpace()) {
            i++;
            continue;
        }
        if (ch.isDigit() || ch == '.') {
            QString numStr;
            while (i < len && (expr[i].isDigit() || expr[i] == '.')) {
                numStr += expr[i];
                i++;
            }

            numbers.push(stringToBigFloat(numStr));
            continue;
        }
        if (ch == '-' && (i == 0 || expr[i-1] == '(' ||
                          expr[i-1] == '+' || expr[i-1] == '-' ||
                          expr[i-1] == '*' || expr[i-1] == '/' ||
                          expr[i-1] == '%')) {
            i++;
            if (i >= len) throw QString("Незавершенное выражение");
            QString numStr = "-";
            while (i < len && (expr[i].isDigit() || expr[i] == '.')) {
                numStr += expr[i];
                i++;
            }
            numbers.push(stringToBigFloat(numStr));
            continue;
        }
        if (ch == '(') {
            operators.push(ch);
            i++;
            continue;
        }
        if (ch == ')') {
            while (!operators.isEmpty() && operators.top() != '(') {
                applyOperator();
            }
            if (operators.isEmpty()) throw QString("Несбалансированные скобки");
            operators.pop(); // Убираем '('
            i++;
            continue;
        }
        if (ch == '+' || ch == '-' || ch == '*' || ch == '/' || ch == '%') {
            while (!operators.isEmpty() && precedence(operators.top()) >= precedence(ch)) {
                applyOperator();
            }
            operators.push(ch);
            i++;
            continue;
        }
        throw QString("Неизвестный символ: " + QString(ch));
    }
    while (!operators.isEmpty()) {
        if (operators.top() == '(') throw QString("Несбалансированные скобки");
        applyOperator();
    }
    if (numbers.size() != 1) throw QString("Некорректное выражение");
    return numbers.top();
}

bool Calculator::isValidExpr(const QString& expr){
    int balance = 0;
    for (QChar ch : expr) {
        if (ch == '(') balance++;
        else if (ch == ')') balance--;
        if (balance < 0) return false;
    }
    return balance == 0;
}

QString Calculator::formatNumber(const BigFloat& num){
    return bigFloatToString(num);
}
