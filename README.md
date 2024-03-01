<h1>Форматы файлов</h1>

<details><summary>типы данных</summary>
<h3>string</h3>
Все строковые значения представлены этим типом. В файлах могут встречаться строки нулевой длины.
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Len<td>dword<td>Длина строки
<tr><td>Text<td>byte<td>Текст в кодировке win-1251, если поле <b>len</b> равно 0, то поле <b>text</b> отсутствует
</table>
<h3>time</h3>
В этом типе представлено время действия эффектов. Итоговое значение расчитывается по формуле  <b>hi*(hi<2?30:60)+lo</b>.
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Hi<td>byte<td>Старший байт
<tr><td>Lo<td>byte<td>Младший байт
</table></details>

<details><summary>PAK (package)</summary>
Файлы с расширением <b>pak</b> - это игровые архивы
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Magic<td>qword<td>Должно содержать текст "PAK " и 4 нулевых байта
<tr><td>FileCount<td>dword<td>Количество файлов в архиве
<tr><td>FAT<td>массив структур<td>Файловая таблица. Массив структур
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Name<td>string<td>Имя файла
<tr><td>Size<td>dword<td>Размер файла в архиве (сжатый размер)
<tr><td>Offset<td>dword<td>Смещение от начала файла
</table>
</table>
Поле <b>offset</b> указывает на такую структуру
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>compressed<td>dword<td>Если равно 0 то файл сжат при помощи <b>zlib</b> (следом за этим полем идёт размер несжатых данных и поток <b>zlib</b>)
<tr><td>data<td>-<td>Сжатые либо несжатые данные
</table></details>

<details><summary>CSX</summary>
В файлах с расширением <b>csx</b> хранятся спрайты с палитрой.
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>ColorCount<td>dword<td>Количество цветов в палитре
<tr><td>TransparentColor<td>dword<td>Прозрачный цвет в формате BGR
<tr><td>Palette<td>dword<td>Плаитра в формате BGR (массив <b>dword</b>, длиной в <b>ColorCount</b> элементов). 
<tr><td>Width<td>dword<td>Ширина изображения
<tr><td>Height<td>dword<td>Высота изображения
<tr><td>Offsets<td>dword<td>Массив смещений строк в массиве <b>CompressedData</b>. В массиве содержится <b>Height+1</b> элементов, последний элемент равен размеру массива <b>CompressedData</b>.
<tr><td>CompressedData<td>-<td>Данные, сжатые по алгоритму <b>RLE</b> (подробности смотри <a href=https://github.com/fersatgit/Goldenland-2-Cold-Heaven/blob/main/XnView%20plugin/Xcsx.dpr>здесь</a>)
</table></details>

<details><summary>SDB (string data base)</summary>
В файлах с расширением <b>sdb</b> хранятся пары значений индекс-строка. Если первые 4 байта не содержат текст "SDB ", то файл зашифрован (к текстовым данным применено исключающее или со значением 0xAA).
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Signature<td>dword<td>Должно содержать текст "SDB ", если это не так - поле отсутствует
<tr><td>Data<td>массив структур<td>Содержит пары значений "идентификатор - строка"
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Id<td>dword<td>Идентификатор строки
<tr><td>Value<td>string<td>Непосредственно строка. Если поле <b>signature</b> отсутствует в файле, то поле <b>text</b> структуры <b>string</b> поксорено ключом <b>0XAA</b> .
</table></table></details>

<details><summary>ITM (item)</summary>
В файлах с расширением <b>itm</b> хранится итформация о предмете инвентаря. Имя файла - это идентификатор предмета (<b>itemId</b>). 
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Magic<td>dword<td>Всегда равно 4
<tr><td>DescriptionID<td>dword<td>Идентификатор строки описания (хранится в файле "sdb\items\descriptions.sdb")
<tr><td>ItemType<td>dword<td>Тип предмета, может содержать одно из значений<ol start=0>
<li>меч
<li>топор
<li>копьё
<li>лук
<li>арбалет
<li>винтовка
<li>посох
<li>дробящее оружие
<li>патроны
<li>болты
<li>стрелы
<li>шлем
<li>кираса
<li>щит
<li>поножи
<li>браслет
<li>амулет
<li>кольцо
<li>деньги
<li>зелье
<li>еда
<li>книга
<li>свиток
<li>кузнечный материал
<li>алхимический ингридиент
<li>квестовый предмет
<li>рецепт
<li>мусор
<li>камень
</ol>
<tr><td>ItemFlags<td>dword<td>Флаги (число слева - это индекс бита)<ol start=0>
<li>двуручный
<li>не известно
<li>установлен на всех экипируемых предметах кроме метательного оружия
<li>неразрушимый
<li>если установлен, то в файле присутствует поле <b>Shell</b>
<li>уникальный
<li>проклятый
<li>не известно
<li>кованый
<li value=30>не известно
<li value=31>не известно
<tr><td>MaxStack<td>dword<td>Максимальное количество предметов в одной ячейке инвентаря
<tr><td>PuppetName<td>string<td>Путь к bmp-файлу для отображения экипируемых предметов на персонаже (в окне инвентаря). Для неэкипируемых предметов это строка нулевой длины.
<tr><td>IconName<td>string<td>Путь к bmp-файлу иконки инвентаря. В игре присутствуют предметы для NPC без иконок, в этом случае это строка нудевой длины.
<tr><td>-<td>qword<td>Назначение поля не известно, может содержать 0 или 1
<tr><td>Price<td>dword<td>Базовая цена предмета
<tr><td>Weight<td>dword<td>Вес предмета, умноженый на 10
<tr><td>-<td>qword<td>Назначение поля не известно. Значения кореллируют с типом материала.
<tr><td>-<td rowspan=5>dword<td rowspan=5>Назначение этих полей не известно.
<tr><td>-
<tr><td>-
<tr><td>-
<tr><td>-
<tr><td>Material<td>dword<td>Индекс строки с названием материала (хранится в файле "sdb\items\materials.sdb"). Если равно -1, то считается, что материал не задан.
<tr><td>Shell<td>string<td>Идентификатор снаряда для отображения при стрельбе/метании соответствует имени mdf-файла в каталоге <b>magic</b>. Это поле присутствует только при установленном флаге в <b>ItemFlags</b>.
<tr><td>Level<td>dword<td>Требование к уровню
<tr><td>Strenght<td>dword<td>Требование к силе
<tr><td>Wisdom<td>dword<td>Требование к мудрости
<tr><td>Endurance<td>dword<td>Требование к выносливости
<tr><td>Intelligence<td>dword<td>Требование к интеллекту
<tr><td>Perception<td>dword<td>Требование к восприятию
<tr><td>Agility<td>dword<td>Требование к ловкости
<tr><td>Damage<td>структура<td>Это поле присутствует только для оружия или доспехов и содержит следующую структуру:
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>CrushMin<td>dword<td rowspan=2>Диапазон дробящего повреждения или защиты от дробящих повреждений
<tr><td>CrushMax<td>dword
<tr><td>HackMin<td>dword<td rowspan=2>Диапазон рубящего повреждения или защиты от рубящих повреждений
<tr><td>HackMax<td>dword
<tr><td>SlashMin<td>dword<td rowspan=2>Диапазон колющего повреждения или защиты от колющих повреждений
<tr><td>SlashMax<td>dword
</table>
<tr><td>Spell<td>структура<td>Это поле присутствует только для посохов,книг или рецептов и содержит следующую структуру:
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>SpellId<td>dword<td>Идентификатор заклинания (имя заклинания хранится в файле "sdb\magic\magiclitnames.sdb")
<tr><td>-<td>dword<td>Всегда равно 0
</table>
<tr><td>Charge<td>dword<td>Это поле присутствует только для посохов и содержит количество зарядов
<tr><td>Healing<td>структура<td>Это поле присутствует только для еды или зелий и содержит следующую структуру:
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Health<td>dword<td>Модификатор здоровья
<tr><td>Mana<td>dword<td>Модификатор маны
</table>
<tr><td>Receipe<td>структура<td>Это поле присутствует только для рецептов и содержит следующую структуру (идетификатор предмета - это имя соответсвующего itm-файла):
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>ItemId1<td>dword<td>Идентификатор первого предмета для комбинации
<tr><td>ItemId2<td>dword<td>Идентификатор второго предмета для комбинации
<tr><td>ResultItemId<td>dword<td>Идентификатор предмета, который получится в результате
</table>
<tr><td>DamageType<td>dword<td>Это поле присутствует только для стрел, болтов или патронов и содержит набор флагов, определяющих тип повреждения (число слева - это индекс бита)<ol start=0>
<li>Дробящее
<li>Рубящее
<li>Колющее
<tr><td>EffectsCount<td>dword<td>Количество эффектов (длина последующего массива), если эффектов нет, то это поле равно 0. Экспериментально установлено, что игра не воспринимает больше 20 эффектов на одном предмете.
<tr><td>Effects<td>массив структур<td>Эффекты, накладываемые предметом описываются такой структурой:
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>Type<td>dword<td>Тип эффекта (описание типов хранится в файле "scripts\item_class_specials\init.scr"). Может принимать одно из следующих значений:<ol start=0>
<li>повреждение ядом
<li>повреждение холодом
<li>повреждение огнём
<li>сопротивление яду
<li>сопротивление холоду
<li>сопротивление огню
<li>сила
<li>телосложение
<li>внимание
<li>ловкость
<li>интелект
<li>мудрость
<li>удача
<li>сопротивляемость магии богов
<li>сопротивляемость магии стихий
<li>сопротивляемость магии света
<li>сопротивляемость магии тьмы
<li>сопротивляемость магии теней
<li>сопротивляемость магии природы
<li>сопротивляемость рубящим повреждениям
<li>сопротивляемость дробящим повреждениям
<li>сопротивляемость колющим повреждениям
<li>максимальное количество здоровья
<li>максимальное количество энергии
<li>инициатива
<li>скорость восстановления здоровья
<li>скорость восстановления энергии
<li>очки действия
<li>слава
<li>класс брони
<li>переносимый вес
<li>воровство жизни
<li>воровство энергии
<li>рубящие повреждения
<li>дробящие повреждения
<li>колющие повреждения
<li>повреждения магией богов
<li>повреждения магией стихий
<li>повреждения магией света
<li>повреждения магией тьмы
<li>повреждения магией теней
<li>повреждения магией природы
<li>иммунитет к магии богов
<li>иммунитет к магии стихий
<li>иммунитет к магии света
<li>иммунитет к магии тьмы
<li>иммунитет к магии теней
<li>иммунитет к магии природы
<li>здоровье
<li>энергия
<li>точность
<li>Шанс на критический удар
<li>Повреждения при критическом ударе
<li>Шанс на критический промах
<li>Разговорчивость
<li>Осторожность
<li>Меткость выстрела
<li>Стрелковые повреждения
<li>Призыв привидения
<li>Один безопасный переход по карте
<li>Призыв горного демона
<li>Призыв крылатого демона
<li>Снятие всех заклинаний, наложенных на цель
<li>Невозможность использования заклинаний целью
<li>Призыв виолии
<tr><td>Amount<td>dword<td>Сила эффекта. В зависимости от установленных флагов может интерпретироваться как непосредственное значение либо как значение в процентах.
<tr><td>Flags<td>dword<td>Флаги (число слева - это индекс бита)<ol start=0>
<li>Эффект действует постоянно
<li>Эффект действует только днём
<li>Эффект действует только ночью
<li value=4>Поле <b>Duration</b> содержит действительное значение
<li>Поле <b>Delay</b> содержит действительное значение
<li>Поле <b>Delay</b> содержит действительное значение
<li>Поле <b>Amount</b> содержит непосредственное значение
<li>Поле <b>Amount</b> содержит значение в процентах
<li>Предназначение не известно. Этот флаг встречается на эффектах в предметах для NPC
<tr><td>Duration<td>time<td>Время действия эффекта в ходах (смотри описание типа time) 
<tr><td>Delay<td>time<td>Задержка действия эффекта в ходах (смотри описание типа time)
</table></table></details>

<h1>Консольные команды</h1>
Для активации консоли нужно добавить в файл "ColdHeaven.ini" строчку "d_console 1" (к слову здесь можно прописать любую команду из списка). В игре консоль вызывается тильдой. В консоли работают сочетания клавиш <b>Ctrl+C</b> и <b>Ctrl+V</b>, нажатием клавиши <b>Tab</b> можно перебирать консольные команды.<p>

<details><summary>префикс cс</summary><table><ul>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>cc_default<td>
<tr><td>cc_unique_or_quest<td>
<tr><td>cc_magical<td>
<tr><td>cc_common<td>
<tr><td>cc_cursed<td>
<tr><td>cc_not_enough<td>
<tr><td>cc_pars_std<td>
<tr><td>cc_pars_not_enough<td>
<tr><td>cc_special<td>
<tr><td>cc_description<td>
</table></ul></details>


<details><summary>Читы (префикс ch - cheats)</summary><ul><table>
Для того, чтобы активировать команды из этого списка, нужно использовать команду "sv_cheats 1".<p>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>ch_add_exp<td>количество опыта<td>Добавить указанное количество опыта главному герою.
<tr><td>ch_all_skill<td>-<td>Установить значиние всех навыков в максимум, заданый командой <b>ch_max_skill_value</b>.
<tr><td>ch_finish_game<td>-<td>Завершить игру.
<tr><td>ch_give<td>&ltItemId&gt &ltколичество&gt<td>Добавить указаное количество предметов в инвентарь. <b>ItemID</b> можно посмотреть в <a href=https://github.com/fersatgit/Goldenland-2-Cold-Heaven/blob/main/%D0%A1%D0%BF%D0%B8%D1%81%D0%BE%D0%BA%20%D0%BF%D1%80%D0%B5%D0%B4%D0%BC%D0%B5%D1%82%D0%BE%D0%B2.xls>списке предметов</a>.
<tr><td>ch_god<td>1 или 0<td>Включить или выключить бесммертие главного героя.
<tr><td>ch_KrepkajaSpina<td>1 или 0<td>При активации вес предметов инвентаря не учитывается (главный герой не может быть перегружен).
<tr><td>ch_max_skill_value<td>Макксимальное значение навыков<td>Задаёт предел развития навыков.
<tr><td>ch_max_primary_value<td>Макксимальное значение характеристик<td>Задаёт предел развития характеристик.
<tr><td>ch_money<td>-<td>Отображает текущее количество денег у главного героя.
<tr><td>ch_skip_random_meet<td><td>
<tr><td>ch_ZorkijGlaz<td><td>
</table></ul></details>


<details><summary>Клиент (префикс cl - client)</summary><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>cl_bpd<td>1 или 0<td>Bytes per datagram
<tr><td>cl_bpd_limit_to_show<td><td>
<tr><td>cl_bpf<td>1 или 0<td>Bytes per frame
<tr><td>cl_bpf_limit_to_show<td><td>
<tr><td>cl_console_time<td><td>
<tr><td>cl_GXFps<td><td>
<tr><td>cl_mini_console_lines<td><td>
<tr><td>cl_reconnecttime<td><td>
<tr><td>cl_timeout<td><td>
<tr><td>cl_traffic<td><td>
<tr><td>cl_username<td>-<td>Отобразить имя главного героя.
<tr><td>cl_skinname<td><td>
<tr><td>cl_spawn<td><td>
</table></ul></details>


<details><summary>Отладка (префикс d - debug)</summary><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>d_console<td>1 или 0<td>Включить или выключить консоль.
<tr><td>d_up_window<td><td>
<tr><td>d_log_person<td><td>
<tr><td>d_location<td>-<td>Отобразить название текущей локации.
<tr><td>d_test_magic<td><td>
<tr><td>d_info_persons<td>1 или 0<td>Включить или выключить отображение технической информации о персонажах.
<tr><td>d_info_role<td>1 или 0<td>Включить или выключить отображение характеристик персонажей.
<tr><td>d_info_items<td>1 или 0<td>Включить или выключить отображение количества предметов на карте.
<tr><td>d_info_world<td>1 или 0<td>Включить или выключить отображение названия карты и коодинат мыши.
<tr><td>d_info_tbsynchr<td><td>
<tr><td>d_info_global_map<td>1 или 0<td>Включить или выключить отображение информации на глобальной карте (id зон и персонажей, вероятность встречи, координаты).
<tr><td>d_info_phrases<td>1 или 0<td>Включить или выключить отображение id фраз в диалогах.
<tr><td>d_go_to_cast<td><td>
<tr><td>d_test<td><td>
<tr><td>d_color<td><td>
<tr><td>d_spritex_holder<td><td>
<tr><td>d_sound_shaders<td><td>
<tr><td>d_user_function<td><td>
<tr><td>d_persons_path<td><td>
<tr><td>d_persons<td><td>
<tr><td>d_triggers<td><td>
<tr><td>d_magic<td><td>
<tr><td>d_net<td><td>
<tr><td>d_history_log<td><td>
<tr><td>d_random_generate<td><td>
<tr><td>d_area_load<td><td>
<tr><td>d_create_dialogs_cache<td><td>
<tr><td>d_minimize_idle<td><td>
<tr><td>d_update_idle<td><td>
<tr><td>d_hooks<td><td>
</table></ul></details>


<details><summary>Глобальные переменные (префикс gv - global variables)</summary><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>gv_addon<td><td>
<tr><td>gv_debug_dialog<td><td>
<tr><td>gv_Title<td>-<td>Отобразить версию игры
<tr><td>gv_double_click_speed<td><td>
<tr><td>gv_mouse_speed<td><td>
<tr><td>gv_MouseAutoRepeatFirstDelay<td><td>
<tr><td>gv_MouseAutoRepeatNextDelay<td><td>
<tr><td>gv_OnHintDelay<td><td>
<tr><td>gv_OnFastHintDelay<td><td>
<tr><td>gv_day_night<td>1 или 0<td>Установить время суток 0 - день, 1 - ночь.
<tr><td>gv_weather<td><td>
<tr><td>gv_Weather_min_delay<td><td>
<tr><td>gv_Weather_max_delay<td><td>
<tr><td>gv_blood<td><td>
<tr><td>gv_cgc_sync<td><td>
<tr><td>gv_item_transaction_timeout<td><td>
<tr><td>gv_item_using_timeout<td><td>
<tr><td>gv_scroll_speed<td><td>
<tr><td>gv_minimap_scroll_speed<td><td>
<tr><td>gv_change_location<td><td>
<tr><td>gv_clip_path_calc<td><td>
<tr><td>gv_loading_jpg<td><td>
<tr><td>gv_in_game<td><td>
<tr><td>gv_is_multiplayer<td><td>
<tr><td>gv_tcpip_ok<td><td>
<tr><td>gv_free_camera<td>1 или 0<td>Включить или выключить привязку камеры к главному герою.
<tr><td>gv_dialog_hacker<td><td>
<tr><td>gv_minimap_alpha<td>от 0.0 до 1.0<td>Установить значение прозрачности миникарты.
<tr><td>gv_minimap_step_scale<td><td>
<tr><td>gv_minimap_show<td>1 или 0<td>Включить или выключить отображение миникарты.
<tr><td>gv_minimap_detail<td><td>
<tr><td>gv_minimap_smooth_scroll<td><td>
<tr><td>gv_seconds_per_turn<td><td>
<tr><td>gv_relax_time_factor<td><td>
<tr><td>gv_SkillPtsPerLevel<td><td>
<tr><td>gv_HeroPtsPerLevel<td><td>
<tr><td>gv_titles_speed<td><td>
<tr><td>gv_disable_scroll<td><td>
<tr><td>gv_gm_step_delay<td>Задержка в миллисекундах<td>Установить задержку между кадрами на глобальной карте.
<tr><td>gv_location_start<td>LocationId<td>Задать стартовую локацию при начале новой игры. Id локации можно подсмотреть в каталоге "levels\single". Эта команда работает только из ini-файла.
<tr><td>gv_items_regenerate_interval<td><td>
<tr><td>gv_gm_scroll_delay<td><td>
<tr><td>gv_random_location<td><td>
<tr><td>gv_pause<td>1 или 0<td>Включить или выключить паузу.
<tr><td>gv_pause_between_turn<td><td>
<tr><td>gv_pause_start_round<td><td>
<tr><td>gv_person_tips<td><td>
<tr><td>gv_status_bar_show_time<td><td>
<tr><td>gv_status_bar_history_depth<td><td>
<tr><td>gv_status_bar_show_history<td><td>
<tr><td>gv_sound_effect_vol<td><td>
<tr><td>gv_sound_speak_vol<td><td>
<tr><td>gv_sound_music_vol<td><td>
<tr><td>gv_sound_eax<td><td>
<tr><td>gv_sound_fading<td><td>
<tr><td>gv_run_always<td>1 или 0<td>Включить или выключить постоянный бег для главного героя.
<tr><td>gv_hints_show<td><td>
<tr><td>gv_anim_speed<td>Положительное число<td>Позволяет замедлить анимацию (чем больше значение параметра тем медленнее анимация).
<tr><td>gv_location_cache<td><td>
<tr><td>gv_meet_offset<td><td>
<tr><td>gv_monster_min_dist<td><td>
<tr><td>gv_monster_max_dist<td><td>
<tr><td>gv_exotic_items_transfer<td><td>
<tr><td>gv_map_walker<td>1 или 0<td>Включить или выключить безопасное путешествие по карте.
<tr><td>gv_skip_logo<td>1 или 0<td>Включить или выключить вступительный видеоролик.
</table></ul></details>


<details><summary>Сеть (префикс net - network)</summary><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>net_hostport<td><td>
<tr><td>net_ip<td><td>
<tr><td>net_stress_delaylocal<td><td>
<tr><td>net_stress<td><td>
</table></ul></details>


<details><summary>префикс r</summary><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>r_resolution<td><td>
<tr><td>r_windowed<td>1 или 0<td>Включить или выключить оконный режим (только из ini-файла).
<tr><td>r_masks_show<td><td>
<tr><td>r_masks_mode<td>1 или 0<td>Включить или выключить полупрозрачность объектов, закрывающих персонажа.
<tr><td>r_baselines_show<td><td>
<tr><td>r_masked_show<td><td>
<tr><td>r_senses_show<td>1 или 0<td>Включить или выключить отображение "чувств" персонажей (видимость и слышимость).
<tr><td>r_senses_limits_show<td>1 или 0<td>Включить или выключить отображение полей зрения и слуха персонажей.
<tr><td>r_person_rect_show<td>1 или 0<td>Включить или выключить прозрачность дляя спрайтов персонажей.
<tr><td>r_shadow_rect_show<td>1 или 0<td>Включить или выключить прозрачность дляя спрайтов теней.
<tr><td>r_noway_show<td><td>
<tr><td>r_noview_show<td><td>
<tr><td>r_triggers_show<td><td>
<tr><td>r_gamma<td><td>
<tr><td>r_antialiasing<td><td>
<tr><td>r_max_texture_width<td><td>
<tr><td>r_fps_show<td>1 или 0<td>Включить или выключить отображение FPS.
</table></ul></details>


<details><summary>префикс sv</summary><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>sv_hostname<td><td>
<tr><td>sv_cheats<td>1 или 0<td>Включить или выключить команды с префиксом "ch_".
<tr><td>sv_demo<td><td>
<tr><td>sv_start_rec_demo<td><td>
<tr><td>sv_game_speed<td><td>
<tr><td>sv_fps<td>кадры в секунду<td>Установить FPS для анимаций.
<tr><td>sv_localhost<td><td>
<tr><td>sv_maxclients<td><td>
<tr><td>sv_dedicated<td><td>
<tr><td>sv_multiplayer<td><td>
</table></ul></details>


<details><summary>Горячие клавиши (префикс vk - virtual key)</summary><ul>
Эти команды отображают код клавиши, назначеной какому-либо действию. Переназначить клавиши можно только из ini-файла при помощи команды <b>bind</b>. В качестве параметра принимаются константы с префиксом DIK<p>
<details><summary>Список констант</summary><ul><table>
<tr><th>Константа<th>Значение
<tr><td>DIK_ESCAPE<td>1
<tr><td>DIK_1<td>2
<tr><td>DIK_2<td>3
<tr><td>DIK_3<td>4
<tr><td>DIK_4<td>5
<tr><td>DIK_5<td>6
<tr><td>DIK_6<td>7
<tr><td>DIK_7<td>8
<tr><td>DIK_8<td>9
<tr><td>DIK_9<td>0Ah
<tr><td>DIK_0<td>0Bh
<tr><td>DIK_MINUS<td>0Ch
<tr><td>DIK_EQUALS<td>0Dh
<tr><td>DIK_BACK<td>0Eh
<tr><td>DIK_TAB<td>0Fh
<tr><td>DIK_Q<td>10h
<tr><td>DIK_W<td>11h
<tr><td>DIK_E<td>12h
<tr><td>DIK_R<td>13h
<tr><td>DIK_T<td>14h
<tr><td>DIK_Y<td>15h
<tr><td>DIK_U<td>16h
<tr><td>DIK_I<td>17h
<tr><td>DIK_O<td>18h
<tr><td>DIK_P<td>19h
<tr><td>DIK_LBRACKET<td>1Ah
<tr><td>DIK_RBRACKET<td>1Bh
<tr><td>DIK_RETURN<td>1Ch
<tr><td>DIK_LCONTROL<td>1Dh
<tr><td>DIK_A<td>1Eh
<tr><td>DIK_S<td>1Fh
<tr><td>DIK_D<td>20h
<tr><td>DIK_F<td>21h
<tr><td>DIK_G<td>22h
<tr><td>DIK_H<td>23h
<tr><td>DIK_J<td>24h
<tr><td>DIK_K<td>25h
<tr><td>DIK_L<td>26h
<tr><td>DIK_SEMICOLON<td>27h
<tr><td>DIK_APOSTROPHE<td>28h
<tr><td>DIK_GRAVE<td>29h
<tr><td>DIK_LSHIFT<td>2Ah
<tr><td>DIK_BACKSLASH<td>2Bh
<tr><td>DIK_Z<td>2Ch
<tr><td>DIK_X<td>2Dh
<tr><td>DIK_C<td>2Eh
<tr><td>DIK_V<td>2Fh
<tr><td>DIK_B<td>30h
<tr><td>DIK_N<td>31h
<tr><td>DIK_M<td>32h
<tr><td>DIK_COMMA<td>33h
<tr><td>DIK_PERIOD<td>34h
<tr><td>DIK_SLASH<td>35h
<tr><td>DIK_RSHIFT<td>36h
<tr><td>DIK_MULTIPLY<td>37h
<tr><td>DIK_LMENU<td>38h
<tr><td>DIK_SPACE<td>39h
<tr><td>DIK_CAPITAL<td>3Ah
<tr><td>DIK_F1<td>3Bh
<tr><td>DIK_F2<td>3Ch
<tr><td>DIK_F3<td>3Dh
<tr><td>DIK_F4<td>3Eh
<tr><td>DIK_F5<td>3Fh
<tr><td>DIK_F6<td>40h
<tr><td>DIK_F7<td>41h
<tr><td>DIK_F8<td>42h
<tr><td>DIK_F9<td>43h
<tr><td>DIK_F10<td>44h
<tr><td>DIK_SCROLL<td>46h
<tr><td>DIK_NUMPAD7<td>47h
<tr><td>DIK_NUMPAD8<td>48h
<tr><td>DIK_NUMPAD9<td>49h
<tr><td>DIK_SUBTRACT<td>4Ah
<tr><td>DIK_NUMPAD4<td>4Bh
<tr><td>DIK_NUMPAD5<td>4Ch
<tr><td>DIK_NUMPAD6<td>4Dh
<tr><td>DIK_ADD<td>4Eh
<tr><td>DIK_NUMPAD1<td>4Fh
<tr><td>DIK_NUMPAD2<td>50h
<tr><td>DIK_NUMPAD3<td>51h
<tr><td>DIK_NUMPAD0<td>52h
<tr><td>DIK_DECIMAL<td>53h
<tr><td>DIK_OEM_102<td>56h
<tr><td>DIK_F11<td>57h
<tr><td>DIK_F12<td>58h
<tr><td>DIK_F13<td>64h
<tr><td>DIK_F14<td>65h
<tr><td>DIK_F15<td>66h
<tr><td>DIK_KANA<td>70h
<tr><td>DIK_ABNT_C1<td>73h
<tr><td>DIK_CONVERT<td>79h
<tr><td>DIK_NOCONVERT<td>7Bh
<tr><td>DIK_YEN<td>7Dh
<tr><td>DIK_ABNT_C2<td>7Eh
<tr><td>DIK_NUMPADEQUALS<td>8Dh
<tr><td>DIK_PREVTRACK<td>90h
<tr><td>DIK_AT<td>91h
<tr><td>DIK_COLON<td>92h
<tr><td>DIK_UNDERLINE<td>93h
<tr><td>DIK_KANJI<td>94h
<tr><td>DIK_STOP<td>95h
<tr><td>DIK_AX<td>96h
<tr><td>DIK_UNLABELED<td>97h
<tr><td>DIK_NEXTTRACK<td>99h
<tr><td>DIK_NUMPADENTER<td>9Ch
<tr><td>DIK_RCONTROL<td>9Dh
<tr><td>DIK_MUTE<td>0A0h
<tr><td>DIK_CALCULATOR<td>0A1h
<tr><td>DIK_PLAYPAUSE<td>0A2h
<tr><td>DIK_MEDIASTOP<td>0A4h
<tr><td>DIK_VOLUMEDOWN<td>0AEh
<tr><td>DIK_VOLUMEUP<td>0B0h
<tr><td>DIK_WEBHOME<td>0B2h
<tr><td>DIK_NUMPADCOMMA<td>0B3h
<tr><td>DIK_DIVIDE<td>0B5h
<tr><td>DIK_SYSRQ<td>0B7h
<tr><td>DIK_RMENU<td>0B8h
<tr><td>DIK_PAUSE<td>0C5h
<tr><td>DIK_HOME<td>0C7h
<tr><td>DIK_UP<td>0C8h
<tr><td>DIK_PRIOR<td>0C9h
<tr><td>DIK_SYSRQ<td>0B7h
<tr><td>DIK_LEFT<td>0CBh
<tr><td>DIK_RIGHT<td>0CDh
<tr><td>DIK_END<td>0CFh
<tr><td>DIK_DOWN<td>0D0h
<tr><td>DIK_NEXT<td>0D1h
<tr><td>DIK_INSERT<td>0D2h
<tr><td>DIK_DELETE<td>0D3h
<tr><td>DIK_LWIN<td>0DBh
<tr><td>DIK_RWIN<td>0DCh
<tr><td>DIK_APPS<td>0DDh
<tr><td>DIK_POWER<td>0DEh
<tr><td>DIK_SLEEP<td>0DFh
<tr><td>DIK_WAKE<td>0E3h
<tr><td>DIK_WEBSEARCH<td>0E5h
<tr><td>DIK_WEBFAVORITES<td>0E6h
<tr><td>DIK_WEBREFRESH<td>0E7h
<tr><td>DIK_WEBSTOP<td>0E8h
<tr><td>DIK_WEBFORWARD<td>0E9h
<tr><td>DIK_WEBBACK<td>0EAh
<tr><td>DIK_MYCOMPUTER<td>0EBh
<tr><td>DIK_MAIL<td>0ECh
<tr><td>DIK_MEDIASELECT<td>0EDh
</table></ul></details><p><table>
<tr><th>Команда<th>Описание
<tr><td>vk_screenshot<td>Сделать снимок экрана
<tr><td>vk_player_info<td>Отобразить статистику персонажа аля Counter-Strike
<tr><td>vk_spawn_player<td>
<tr><td>vk_magic_test<td>Отобразить окно отладки заклинаний
<tr><td>vk_location_test<td>
<tr><td>vk_minimap_increase<td>Увеличить видимый размер миникарты
<tr><td>vk_minimap_decrease<td>Уменьшить видимый размер миникарты
<tr><td>vk_minimap_show<td>Переключение видимости миникарты
<tr><td>vk_free_camera<td>Привязка камеры к главному герою
<tr><td>vk_menu_toggle<td>Отобразить меню
<tr><td>vk_quick_save<td>Быстрое сохранение
<tr><td>vk_quick_load<td>Быстрая загрузка
<tr><td>vk_speed_up<td>
<tr><td>vk_speed_down<td>
<tr><td>vk_skip_turn<td>Пропустить ход
<tr><td>vk_dlghot_1<td rowspan=10>Варианты ответов в диалогах/использование горячих слотов
<tr><td>vk_dlghot_2
<tr><td>vk_dlghot_3
<tr><td>vk_dlghot_4
<tr><td>vk_dlghot_5
<tr><td>vk_dlghot_6
<tr><td>vk_dlghot_7
<tr><td>vk_dlghot_8
<tr><td>vk_dlghot_9
<tr><td>vk_dlghot_0
<tr><td>vk_left_arrow<td rowspan=4>Прокрутка (скролинг)
<tr><td>vk_right_arrow
<tr><td>vk_up_arrow
<tr><td>vk_down_arrow
<tr><td>vk_lshift<td>
<tr><td>vk_rshift<td>
<tr><td>vk_relaxation<td>Активировать режим отдыха
<tr><td>vk_inventory_show<td>Открыть инвентарь
<tr><td>vk_globalmap_show<td>Открыть глобальную карту
<tr><td>vk_magicbook_show<td>Открыть книгу заклинаний
<tr><td>vk_diary_show<td>Показать дневник
<tr><td>vk_stealing<td>Кража
<tr><td>vk_smith<td>Кузнечное дело
<tr><td>vk_alchemy<td>Алхимия
<tr><td>vk_repairing<td>Починка
<tr><td>vk_staff_charging<td>Зарядка посоха
<tr><td>vk_weapon_toggle<td>Смена текущего оружия
<tr><td>vk_attacktype_toggle<td>Сменить режим атаки
<tr><td>vk_reload_weapon<td>Перезарядить оружие
<tr><td>vk_staff_current_spell<td>Текущее заклинание - посох
<tr><td>vk_magicbook_current_spell<td>Текущее заклинание - из магической книги
<tr><td>vk_activale_aimed_hits<td>Прицельная атака
<tr><td>vk_panel_toggle<td>Отобразить или спрятать нижнюю панель интерфейса
<tr><td>vk_flash_objects<td>Подсветка объектов
<tr><td>vk_flash_objects_alt<td>Подсветка объектов
</table></ul></details>


<details><summary>Разное (без префикса)</summary><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>add_ally<td>-<td>
<tr><td>add_person<td>-<td>
<tr><td>ai_see<td><td>
<tr><td>ai_think<td><td>
<tr><td>ap_set_route<td>-<td>
<tr><td>attach_to_person<td>-<td>
<tr><td>cache_all_dialogs<td>-<td>
<tr><td>connect<td><td>
<tr><td>del_person<td>PersonId<td>Удалить персонажа. <b>PersonId</b> можно узнать командой <b>d_info_persons</b>.
<tr><td>disconnect<td><td>
<tr><td>distance_attack<td>-<td>
<tr><td>exit<td>-<td>Выход из игры
<tr><td>fire_start<td>-<td>
<tr><td>fire_stop<td>-<td>
<tr><td>game_save<td>номер слота<td>Сохраняет игру в указаном слоте.
<tr><td>kill_person<td>PersonId<td>Убить персонажа. <b>PersonId</b> можно узнать командой <b>d_info_persons</b>.
<tr><td>restart<td><td>
<tr><td>set_tb_mode<td>-<td>Включить пошаговый режим.
<tr><td>set_speed<td>модификатор задержки<td>Устанавливает модификатор задержки между кадрами анимации (вещественное число). Значение -1 полностью убирает задержку (максимальная скорость анимации), -0.5 ускоряет анимацию в 2 раза, 1 замедляет анимацию в 2 раза и т.д.
<tr><td>transition<td>LocationId<td>Переместить главного героя на указанную локацию. Id локации можно подсмотреть в каталоге "levels\single".
<tr><td>use_all_magic<td>-<td>Добавить все заклинания в книгу заклинаний.
<tr><td>zombie_time<td><td>
</table></ul></details>


<h1>Скрипты</h1>
<details><ul><table>
<tr><th>Команда<th>Параметры<th>Описание
<tr><td>D_Say
<tr><td>D_CloseDialog
<tr><td>D_Answer
<tr><td>D_PlaySound
<tr><td>Exit
<tr><td>Signal
<tr><td>Console
<tr><td>Cmd
<tr><td>LE_CastEffect
<tr><td>LE_DelEffect
<tr><td>LE_CastMagic
<tr><td>WD_LoadArea
<tr><td>WD_TitlesAndLoadArea
<tr><td>C_TitlesAndFINISHED
<tr><td>WD_SetCellsGroupFlag
<tr><td>RS_SetTribesRelation
<tr><td>RS_GetTribesRelation
<tr><td>RS_StartDialog
<tr><td>WD_SetVisible
<tr><td>C_FINISHED
<tr><td>RS_TestPersonHasItem
<tr><td>RS_PersonTransferItemI
<tr><td>RS_GetItemCountI
<tr><td>RS_PersonTransferAllItemsI
<tr><td>RS_GetMoney
<tr><td>RS_PersonAddItemToTrade
<tr><td>RS_PersonRemoveItemToTrade
<tr><td>RS_PersonAddItem
<tr><td>RS_PersonRemoveItem
<tr><td>RS_GetPersonParameterI
<tr><td>RS_SetPersonParameterI
<tr><td>RS_GetPersonSkillI
<tr><td>RS_AddPerson_1
<tr><td>RS_AddPerson_2
<tr><td>RS_AddExp
<tr><td>RS_IsPersonExistsI
<tr><td>RS_DelPerson
<tr><td>RS_AddToHeroPartyName
<tr><td>RS_RemoveFromHeroPartyName
<tr><td>RS_TestHeroHasPartyName
<tr><td>RS_AllyCmd
<tr><td>RS_ShowMessage
<tr><td>RS_QuestComplete
<tr><td>RS_StageEnable
<tr><td>RS_QuestEnable
<tr><td>RS_StorylineQuestEnable
<tr><td>RS_StageComplete
<tr><td>RS_GetDayOrNight
<tr><td>RS_EnableTrigger
<tr><td>RS_GetRandMinMaxI
<tr><td>RS_GetCurrentTimeOfDayI
<tr><td>RS_GetDaysFromBeginningI
<tr><td>RS_SetEvent
<tr><td>RS_GetEvent
<tr><td>RS_ClearEvent
<tr><td>RS_AddTime
<tr><td>RS_GetDialogEnabled
<tr><td>RS_SetWeather
<tr><td>RS_SetSpecialPerk
<tr><td>RS_PassToTradePanel
<tr><td>RS_SetUndeadState
<tr><td>RS_SetLocationAccess
<tr><td>RS_GlobalMap
<tr><td>RS_SetInjured
<tr><td>RS_SetDoorState
</table></ul></details>


<h1>Разное</h1><ul>
<li>Инструменты от <b>-=CHE@TER=-</b> - <a href=http://www.ctpax-x.org/?goto=files&down=136>скачать</a>
<li>Движок вначале пытается подгрузить распакованные файлы из каталога игры, затем ищёт файлы в архивах. Создателям модификаций будет удобно распаковать архивы в каталог с игрой (не в Data).
