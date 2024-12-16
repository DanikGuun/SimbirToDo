# (Swift 6, iOS 12+): MVC, UIKit, Realm, Core Graphics, Core Animation

<br>

<image height="450" src="https://github.com/user-attachments/assets/c262a841-3317-4e3a-95fd-5390b47b2f79"></image>
<image height="450" src="https://github.com/user-attachments/assets/b8640e2c-4fcc-4ce0-ab82-84fd01b2877e"></image>
<image height="450" src="https://github.com/user-attachments/assets/9512ebb1-3312-425a-923d-55ef8c0df2ed"></image>
<image height="450" src="https://github.com/user-attachments/assets/31d9b0e0-23a1-4084-8314-91ed0f7c8a0b"></image>

<br>

<h1>Тестовое задание в SimbirSoft</h1>
<p>За дизайн идею взял календарь от Apple. Применял такие паттерны как Delegation, Fabric, Strategy. Старался насколько это возможно выдерживать зависимости от абстракции.</p>

<h2>Из интересного:</h2>
<ul>
  <li>Растягивающийся основной таймлайн</li>
  <li>Выбор даты "встроен" в таймлайн</li>
  <li>Поддержка iOS 12</li>
  <li>Темная тема</li>
  <li>Вёрстка на чистом UIKit без StoryBoard</li>
</ul>

<h1>Структура</h1>
  <h2>Model</h2>
  
  <h3>TaskModel</h3>
  <p>Файл с сущностями для дел, где:</p>
  <ul>
    <li type="cirlce">ToDoTask - сущность, которая хранится в Realm</li>
    <li type="cirlce">TaskInfo - содержит информацию от задания. Была создана для передачи во вью, чтобы не связывать View и Model</li>
    <li type="cirlce">TaskMetadata - Содержит внутри себя TaskInfo и данные для корректного отображения на таймлайне</li>
  </ul>
  
  <h3>TaskManager</h3>
  <p>небольшой класс для вспомогательных операцию над задачами</p>
  
  <h3>Behaviors</h3>
  <p>Поведения для обработки задач (паттерн Стратегия)</p>


  <h2>View</h2>
  
  <h3>Button</h3>
  <p>Класс для удобной работы с кнопкой, т.к. на старых iOS конфигурации не работают</p>
  
  <h3>ColorPickView</h3>
  <p>Вьюшка для выбора цвета, при выборе красиво анимируется с помощью Core Animation</p>

  <h3>PlaceHolderTextView</h3>
  <p>Надстройка над UITextView для отображения placeholder, можно переиспользовать)</p>

  <h3>TaskInfoView</h3>
  <p>Представление для дела</p>

  <h3>DailyTaskView</h3>
  <p>Представление для заданий на день</p>
  <ul>
    <li>Имеет в себе TimeLineStackView - временную линию, с ContentLayoutGuide</li>
    <li>Соответсвует TaskPresenterProtocol - протокол, необходимый для подгрузки и очистки заданий</li>
    <li>Для уведомления о событиях использует TaskPresenterDelegate</li>
  </ul>

  <h3>TaskEditTableView</h3>
  <p>TableView с ячейками дла редактирования заданий. Не придумал, как достичь зависимости только от абстракции в ячейках, но общение сделал через протокол</p>
  <ul>
    <li>Соответствует TaskEditerProtocol - проткол, принимающий, или выдающий информацию о задании</li>
    <li>Ячейки соответсвуют протоколу TaskEditCellProtocol - также принимает или отдает данные о задании</li>
  </ul>

  <h2>Controller</h2>
  
  <h3>TaskListController</h3>
  <p>Основной контроллер, состоит из ScrollView, который содержит в себе UIDatePicker и TaskPresenter</p>
  <ul>
    <li>Раскрытие UIDatePicker при протягивании вверх и нажатию кнопки</li>
    <li>Передача данных в TaskPresenter через протокол</li>
    <li>Асинхронная загрузка и обработка заданий</li>
  </ul>

  <h3>TaskEditController</h3>
  <p>Контроллер для изменения информации о зданаии</p>
  <ul>
    <li>Совмещает в себе как создание, так и редактирование задания</li>
    <li>Общается с таблицей через проткол</li>
    <li>Для создания используется паттерн Fabric</li>
  </ul>
