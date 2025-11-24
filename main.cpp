#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "Calculator.h"

// Создаем синглтон провайдер
static QObject *calculator_singleton_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
    Calculator* calculator = new Calculator();
    return calculator;
}

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<Calculator>("Calculator", 1, 0, "Calculator");
    // Регистрируем Calculator как синглтон
    qmlRegisterSingletonType<Calculator>("Calculator", 1, 0, "Calculator", calculator_singleton_provider);
    QQmlApplicationEngine engine;
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Calculator", "Main");
    return app.exec();
}
