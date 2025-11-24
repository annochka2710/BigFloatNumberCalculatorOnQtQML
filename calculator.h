#ifndef CALCULATOR_H
#define CALCULATOR_H

#include <QObject>
#include <QString>
#include <boost/multiprecision/cpp_dec_float.hpp>

class Calculator : public QObject
{
    Q_OBJECT
public:
    Calculator(QObject *parent = nullptr);

    Q_PROPERTY(QString display READ getMathExpr NOTIFY displayChanged)
    Q_PROPERTY(QString result READ getRes NOTIFY resultChanged)

    enum Operations {
        Plus = 0,
        Minus = 1,
        Multiplic = 2,
        Division = 3,
        Percent = 4,
        None = 5
    };

    Q_ENUM(Operations)

    Q_INVOKABLE void append(const QString &num);    //добавить число, знак к выражению
    Q_INVOKABLE void setOper(const QString& oper); //установить матем оператор
    Q_INVOKABLE void calcul(); //вычисление мат выражения
    Q_INVOKABLE void clear();  //сброс калькулятора
    Q_INVOKABLE void addDecimal(); //добавление десятичной точки
    Q_INVOKABLE void changeSign();
    Q_INVOKABLE void addBracket(const QString& bracket); //добавление '(' или ')'
    Q_INVOKABLE void backspace(); //вычисление процента от числа
    Q_INVOKABLE void calcPercent();
    Q_INVOKABLE void setSecretMode(bool val);
    Q_INVOKABLE QString getRes() const;
    Q_INVOKABLE QString getMathExpr() const;

signals:
    void secretMenu();
    void displayChanged(const QString &display);
    void resultChanged(const QString &result);
    void errorHappened(const QString &error);

private:
    using BigFloat = boost::multiprecision::cpp_dec_float_50;

    void updateResult(const BigFloat& res);
    BigFloat evaluateExpr(const QString& expr); //парсер
    bool isValidExpr(const QString& expr);
    QString formatNumber(const BigFloat& num); //форматирование числа
    BigFloat stringToBigFloat(const QString& str);
    QString bigFloatToString(const BigFloat& value);

    QString display;    //мат выражение
    QString result;     //результат вычислений
    bool error = false; //флаг ошибки
    QString secret = "";
    bool secretMode = false; //флаг секрет-мода
};

#endif // CALCULATOR_H
