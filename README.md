<h1>Форматы файлов</h1>

<details><summary>типы данных</summary><div>
<h3>string</h3>
Все строковые значения представлены этим типом. В файлах могут встречаться строки нулевой длины.
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>len<td>dword<td>Длина строки
<tr><td>text<td>byte<td>Текст в кодировке win-1251, если поле <b>len</b> равно 0, то поле <b>text</b> отсутствует
</table>
<h3>time</h3>
В этом типе представлено время действия эффектов. Итоговое значение расчитывается по формуле  <b>hi*(hi<2?30:60)+lo</b>.
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>hi<td>byte<td>Старший байт
<tr><td>lo<td>byte<td>Младший байт
</table></div></details>

<details><summary>SDB (string data base)</summary><div>
В файлах с расширением <b>sdb</b> хранятся пары значений индекс-строка. Если первые 4 байта не содержат текст "SDB ", то файл зашифрован (к текстовым данным применено исключающее или со значением 0xAA).
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>signature<td>dword<td>Должно содержать текст "SDB ", если это не так - поле отсутствует
<tr><td>data<td>массив структур<td>Содержит пары значений "идентификатор - строка"
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>id<td>dword<td>Идентификатор строки
<tr><td>value<td>string<td>Непосредственно строка. Если поле <b>signature</b> отсутствует в файле, то поле <b>text</b> структуры <b>string</b> поксорено ключом <b>0XAA</b> .
</table>
</table></div></details>

<details><summary>ITM (item)</summary><div>
В файлах с расширением <b>itm</b> хранится итформация о предмете инвентаря. Имя файла - это идентификатор предмета (<b>itemId</b>). 
<table><tr><th>Имя поля<th>тип<th>описание
<tr><td>magic<td>dword<td>Равно 4
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
<tr><td>-<td rowspan=5>dword<td rowspan=5>Назначение этих полей неизвестно.
<tr><td>-
<tr><td>-
<tr><td>-
<tr><td>-
<tr><td>Material<td>dword<td>Индекс строки с названием материала (хранится в файле "sdb\items\materials.sdb"). Если равно -1, то считается, что материал не задан.
<tr><td>Shell<td>string<td>Идентификатор снаряда для отображения при стрельбе/метании. Это поле присутствует только при установленном флаге в <b>ItemFlags</b> и может принимать следующие значения:<ul>
<li>WPN_arrow
<li>WPN_axe
<li>WPN_bolt
<li>WPN_dagger
<li>WPN_spear
<li>WPN_stone
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
<tr><td>Type<td>dword<td>Тип эффекта. Может принимать одно из следующих значений:<ol start=0>
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
<li>снятие всех заклинаний, наложеных на цель
<li>один безопасный переход по карте
<li>невозможность использования заклинаний целью
<li>призыв привидения
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
</table>
</table></div></details>
