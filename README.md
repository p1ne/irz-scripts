<div dir="ltr" style="text-align: left;" trbidi="on">
Данный репозиторий унаследован от <a href="https://github.com/p1ne/openwrt-scripts">https://github.com/p1ne/openwrt-scipts</a> <br />
В репозитории <a href="https://github.com/p1ne/irz-scripts">https://github.com/p1ne/irz-scripts</a> выложены мои скрипты для 3G роутера IRZ RUH2B для использования в автомобиле для следующих задач<br />
<br />
1. Отсылка сообщения с примерным местоположением машины, которое определяется по данным текущей сотовой вышки, если к роутеру подключен 3G-модем<br />
2. Автоматическое переключение раздачи интернета между модемом, подключенным к роутеру и мобильным телефоном в режиме hotspot (в планах)<br />
3. Автоматическая активация бесплатного режима Yota в случае, если к роутеру подключен Yota-модем (в планах)<br />
<br />
Предполагается следующее:<br />
<br />
<ul style="text-align: left;">
<li>на роутере установлен статически собранный curl (также есть в репозитории)
<li>все файлы лежат в каталоге /mnt/rwfs
<li>На странице http://192.168.1.1/cgi-bin/admin_ipup.cgi задан вызов скрипта посылки координат:
</ul>
<br />
<pre>/mnt/rwfs/scripts/get-coordinates-modem-yandex-locator.sh &</pre><br />
<br />
<div>
<br /></div>
Для корректной работы скриптов необходимо задать переменные окружения в файле <a href="https://github.com/p1ne/irz-scripts/blob/master/mnt/rwfs/scripts/variables.sh">/mnt/rwfs/scripts/variables.sh</a><br />
<br />
При помощи переменных задаются параметры точек доступа, ключи для провайдеров координат и сервисов нотификации, а также выбираются скрипты для получения координат и нотификаций.<br />
<br />
<b>Провайдеры координат по данным сотовых вышек (можно использовать только один, под IRZ переработан только Yandex.Locator):</b><br />
OPENCELLID_KEY - opencellid.org, требует регулярной отсылки данных вышек, поэтому может быть не очень удобен ( <a href="http://opencellid.org/#action=database.requestForApiKey">получить ключ</a>&nbsp;)<br />
YANDEX_KEY - Yandex Location API ( <a href="https://tech.yandex.ru/maps/keys/get/">получить ключ</a> )<br />
<br />
<b>Сервисы нотификации (можно использовать только один, под IRZ переработан только NMA)</b><br />
NMA_KEY - Notify My Android для телефонов на Android ( <a href="https://play.google.com/store/apps/details?id=com.usk.app.notifymyandroid">приложение</a>&nbsp;)<br />
QPUSH_CODE, QPUSH_NAME - qpush.me для iPhone ( <a href="https://itunes.apple.com/us/app/qpush-push-text-links-from/id776837597">приложение</a> )<br />
<br />
<b>Точки доступа (сейчас не реализовано для IRZ)</b><br />
ROUTER_AP_NAME, ROUTER_AP_PASSWORD - имя и пароль точки доступа когда доступ в сеть раздается через модем<br />
<br />
PHONE_AP_NAME, PHONE_AP_MAC, PHONE_AP_PASSWORD - имя, MAC-адрес и пароль телефона, раздающего доступ в сеть<br />
<br />
Конфигурацию точек доступа можно посмотреть в <a href="https://github.com/p1ne/openwrt-scripts/blob/master/root/wireless.Modem">/root/wireless.Modem</a> и <a href="https://github.com/p1ne/openwrt-scripts/blob/master/root/wireless.Phone">/root/wireless.Phone</a><br />
<br />
<b>Скрипты</b><br />
NOTIFY_SCRIPT - скрипт нотификации. В названии скрипта указан сервис нотификации и используемая утилита для работы с HTTP-запросами<br />
COORDINATES_SCRIPT - скрипт получения координат. В названии скрипта указано название провайдера координат<br />
YOTA_SCRIPT - скрипт активации бесплатного режима работы Yota. В названии скрипта указана используемая утилита для работы с HTTP-запросами<br />
<br />
Скрипт отсылки координат запускается один раз при поднятии интерфейса 3G модема и установлении соединения<br />
<br /></div>
