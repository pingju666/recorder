#ifndef APPSETTINGS_H
#define APPSETTINGS_H

#include <QObject>
#include <QString>
#include <QSettings>
#include <QStandardPaths>

class AppSettings : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString savePath READ savePath WRITE setSavePath NOTIFY savePathChanged)

public:
    explicit AppSettings(QObject *parent = nullptr) : QObject(parent)
    {
        QSettings settings("QtRecorder", "Settings");
        m_savePath = settings.value("savePath", QStandardPaths::writableLocation(QStandardPaths::MoviesLocation)).toString();
    }

    QString savePath() const { return m_savePath; }
    void setSavePath(const QString &path)
    {
        if (m_savePath != path) {
            m_savePath = path;
            QSettings settings("QtRecorder", "Settings");
            settings.setValue("savePath", path);
            emit savePathChanged();
        }
    }

signals:
    void savePathChanged();

private:
    QString m_savePath;
};

#endif
