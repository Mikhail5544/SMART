spool cp-scrap.log

prompt

prompt Creating table CON_GROUP
prompt ========================
prompt

create table CON_GROUP
(
  dic  NUMBER not null,
  name VARCHAR2(100) not null
)
;
comment on table CON_GROUP
  is 'Группы констант';
comment on column CON_GROUP.dic
  is 'DIC';
comment on column CON_GROUP.name
  is 'Имя группы';
alter table CON_GROUP
  add constraint PK_CON_GROUP primary key (DIC);
grant select on CON_GROUP to F_SMART_RO_ROLE;

prompt

prompt Creating table CONS
prompt ===================
prompt

create table CONS
(
  id        NUMBER not null,
  name      VARCHAR2(100) not null,
  dic       NUMBER not null,
  invisible NUMBER default 0 not null,
  is_minor  NUMBER
)
;
comment on table CONS
  is 'Константы';
comment on column CONS.id
  is 'Номер константы в группе';
comment on column CONS.name
  is 'Значение константы';
comment on column CONS.dic
  is 'DIC группы констант';
comment on column CONS.invisible
  is 'Если 1 то считать занчение устаревшим и не показывать в лукапе на клиенте';
comment on column CONS.is_minor
  is 'Если 1 то считать это значение второстепенным';
create index I_CON_GROUP_REF_FK on CONS (DIC);
create unique index IU_CONS_UNIQUE on CONS (DIC, ID);
create index IU_CONS_UNIQUE2 on CONS (DIC, NAME);
alter table CONS
  add constraint FK_CON_GROUP foreign key (DIC)
  references CON_GROUP (DIC);
grant select on CONS to F_SMART_RO_ROLE;

prompt

prompt Creating table CONST
prompt ====================
prompt

create table CONST
(
  const_name     VARCHAR2(255) not null,
  const_val_num  NUMBER,
  const_val_str  VARCHAR2(4000),
  const_val_date DATE,
  const_note     VARCHAR2(4000)
)
;
comment on table CONST
  is 'Константы';
comment on column CONST.const_name
  is 'Название константы';
comment on column CONST.const_val_num
  is 'Число';
comment on column CONST.const_val_str
  is 'Строка';
comment on column CONST.const_val_date
  is 'Дата';
comment on column CONST.const_note
  is 'Примечание';
alter table CONST
  add constraint PK_CONST primary key (CONST_NAME);

prompt

prompt Creating table DICS
prompt ===================
prompt

create table DICS
(
  id        INTEGER not null,
  dic       NUMBER,
  name      VARCHAR2(100) not null,
  dic_id    INTEGER,
  grp       NUMBER,
  new       NUMBER(1),
  invisible NUMBER default 0 not null,
  is_minor  NUMBER
)
;
comment on table DICS
  is 'Справочник';
comment on column DICS.id
  is 'ID';
comment on column DICS.dic
  is 'Номер справочника';
comment on column DICS.name
  is 'Значение';
comment on column DICS.dic_id
  is 'Ссылка на синоним';
comment on column DICS.grp
  is 'Группа';
comment on column DICS.new
  is 'Признак нового значения';
comment on column DICS.invisible
  is 'Если 1 то считать занчение устаревшим и не показывать в лукапе на клиенте';
comment on column DICS.is_minor
  is 'Если 1 то считать это значение второстепенным';
create index FK_DICS_DIC_ID on DICS (DIC_ID);
create index I_DICS_DIC on DICS (DIC);
create unique index I_DICS_UNIQUE on DICS (NAME, DIC);
alter table DICS
  add constraint PK_DICS primary key (ID);
alter table DICS
  add constraint FK_DICS_REF_24568_DICS foreign key (DIC_ID)
  references DICS (ID);
grant select on DICS to F_SMART_RO_ROLE;

prompt

prompt Creating table SMART_DSET
prompt =========================
prompt

create table SMART_DSET
(
  id              NUMBER not null,
  fk_id           NUMBER,
  class_name      VARCHAR2(100) not null,
  hide            NUMBER default 0 not null,
  crt_user        VARCHAR2(30) default user not null,
  icon_index      NUMBER default -1 not null,
  con_class_type  NUMBER not null,
  is_delete_class NUMBER,
  note            VARCHAR2(2000),
  is_audit        NUMBER default 0 not null,
  host            VARCHAR2(200) default sys_context('userenv','HOST'),
  config_xml      CLOB
)
;
comment on table SMART_DSET
  is 'Дерево наборов';
comment on column SMART_DSET.id
  is 'ID';
comment on column SMART_DSET.fk_id
  is 'Рекурсивный ключик для построения дерева';
comment on column SMART_DSET.class_name
  is 'Наименование набора данных';
comment on column SMART_DSET.hide
  is 'При 1 - скрыть набор данных в дереве';
comment on column SMART_DSET.crt_user
  is 'Пользователь создавший набор';
comment on column SMART_DSET.icon_index
  is 'Иконка в менюшке';
comment on column SMART_DSET.con_class_type
  is 'Тип набора: 1 - папка, 10 - композитный набор';
comment on column SMART_DSET.is_delete_class
  is 'При 1 - нельзя удалять класс (используется в клиенте)';
comment on column SMART_DSET.note
  is 'Примечание';
comment on column SMART_DSET.is_audit
  is 'При 1 - выполнять аудит открытия набора данных';
comment on column SMART_DSET.host
  is 'Хост';
create index I_FK_SMART_DSET_CLASS_FK_ID on SMART_DSET (CLASS_NAME, FK_ID);
create index I_FK_SMART_DSET_FK_ID on SMART_DSET (FK_ID);
alter table SMART_DSET
  add constraint PK_SMART_DSET unique (ID);
alter table SMART_DSET
  add constraint FK_SMART_DSET foreign key (FK_ID)
  references SMART_DSET (ID);
grant select on SMART_DSET to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_DSET to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_CLASS
prompt ==========================
prompt

create table SMART_CLASS
(
  id            NUMBER not null,
  fk_id         NUMBER,
  smart_dset_id NUMBER not null,
  sort_num      NUMBER not null,
  ftype         NUMBER not null,
  obj_id        NUMBER,
  name          VARCHAR2(200) not null,
  is_audit      NUMBER default 0 not null,
  tag_id        NUMBER not null
)
;
comment on table SMART_CLASS
  is 'Структура композитного набора';
comment on column SMART_CLASS.id
  is 'ID';
comment on column SMART_CLASS.fk_id
  is 'ID_Набор данных';
comment on column SMART_CLASS.smart_dset_id
  is 'ID_Пользовательский набор';
comment on column SMART_CLASS.sort_num
  is 'Уникальный номер для сортировки';
comment on column SMART_CLASS.ftype
  is 'Тип объекта';
comment on column SMART_CLASS.obj_id
  is 'ID_Пользовательский набор (связь с объектом)';
comment on column SMART_CLASS.name
  is 'Наименование объекта';
comment on column SMART_CLASS.is_audit
  is 'При 1 - выполнять аудит открытия класса';
comment on column SMART_CLASS.tag_id
  is 'Уникальный идентификатор объекта';
create index I_SMART_CLASS_FK_ID on SMART_CLASS (FK_ID);
create index I_SMART_CLASS_OBJ_ID on SMART_CLASS (OBJ_ID);
create index I_SMART_CLASS_SMART_DSET_ID on SMART_CLASS (SMART_DSET_ID);
create unique index IU_SMART_CLASS_SORT_ID on SMART_CLASS (SMART_DSET_ID, SORT_NUM);
alter table SMART_CLASS
  add constraint PK_SMART_CLASS primary key (ID);
alter table SMART_CLASS
  add constraint FK_SMART_CLASS_FK_ID foreign key (FK_ID)
  references SMART_CLASS (ID) on delete cascade;
alter table SMART_CLASS
  add constraint FK_SMART_CLASS_OBJ_ID foreign key (OBJ_ID)
  references SMART_CLASS (ID);
alter table SMART_CLASS
  add constraint FK_SMART_CLASS_SMART_DSET_ID foreign key (SMART_DSET_ID)
  references SMART_DSET (ID) on delete cascade;
grant select on SMART_CLASS to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_CLASS to F_SMART_RW_ROLE;

prompt

prompt Creating table DICS_TREE
prompt ========================
prompt

create table DICS_TREE
(
  id               NUMBER not null,
  dic_tree_id      NUMBER,
  name_folder      VARCHAR2(300) not null,
  image_index      NUMBER not null,
  user_filter      VARCHAR2(30),
  number_dic       NUMBER default -1 not null,
  con_type_dic     NUMBER default -1 not null,
  tree_image_index NUMBER,
  con_tree_num     NUMBER,
  is_null          NUMBER default 0 not null,
  is_not_in        NUMBER default 0 not null,
  sort_num         NUMBER not null,
  smart_class_id   NUMBER
)
;
comment on table DICS_TREE
  is 'Дерево фильтрации для справочников';
comment on column DICS_TREE.id
  is 'ID';
comment on column DICS_TREE.dic_tree_id
  is 'Рекурсивный ключик для построения дерева';
comment on column DICS_TREE.name_folder
  is 'Имя папки';
comment on column DICS_TREE.image_index
  is 'Индекс картинки';
comment on column DICS_TREE.user_filter
  is 'Владелец фильтра';
comment on column DICS_TREE.number_dic
  is 'Номер в справочнике';
comment on column DICS_TREE.con_type_dic
  is 'Тип справочника (1-DIC,2-CON,3-ENUM)';
comment on column DICS_TREE.tree_image_index
  is 'Пользовательская иконка';
comment on column DICS_TREE.con_tree_num
  is 'Номер дерева';
comment on column DICS_TREE.is_null
  is 'При 1 - Пустое поле';
comment on column DICS_TREE.is_not_in
  is 'При 1 - Исключить';
comment on column DICS_TREE.sort_num
  is 'Поле сотировки для построения дерева';
comment on column DICS_TREE.smart_class_id
  is 'ID_Пользовательский набор';
create index I_DICS_TREE_SMART_CLASS_ID on DICS_TREE (SMART_CLASS_ID);
create unique index I_DICS_TREE_SORT_NUM on DICS_TREE (SORT_NUM);
create index I_FK_DIC_TREE_ID on DICS_TREE (DIC_TREE_ID);
alter table DICS_TREE
  add primary key (ID);
alter table DICS_TREE
  add constraint FK_DICS_TREE_SMART_CLASS_ID foreign key (SMART_CLASS_ID)
  references SMART_CLASS (ID) on delete cascade;
alter table DICS_TREE
  add constraint FK_DIC_TREE_ID foreign key (DIC_TREE_ID)
  references DICS_TREE (ID);
grant select, insert, update, delete on DICS_TREE to F_SMART_RO_ROLE;

prompt

prompt Creating table DICS_TREE_ITEM
prompt =============================
prompt

create table DICS_TREE_ITEM
(
  id     NUMBER not null,
  dic_id NUMBER not null,
  value  NUMBER not null
)
;
comment on table DICS_TREE_ITEM
  is 'Элементы  дерева фильтрации для справочников';
comment on column DICS_TREE_ITEM.id
  is 'ID';
comment on column DICS_TREE_ITEM.dic_id
  is 'ID_Дерево фильтрации для справочников';
comment on column DICS_TREE_ITEM.value
  is 'Отмеченное значение';
create index I_DICS_TREE_ITEM_DIC_ID on DICS_TREE_ITEM (DIC_ID);
alter table DICS_TREE_ITEM
  add constraint PK_DICS_TREE_ITEM primary key (ID);
alter table DICS_TREE_ITEM
  add constraint FK_DICS_TREE_ITEM_DIC_ID foreign key (DIC_ID)
  references DICS_TREE (ID) on delete cascade;
grant select, insert, update, delete on DICS_TREE_ITEM to F_SMART_RO_ROLE;

prompt

prompt Creating table FILEHEADER
prompt =========================
prompt

create table FILEHEADER
(
  id            NUMBER not null,
  filename      VARCHAR2(2000) not null,
  filesize      NUMBER(10) not null,
  filedate      DATE default SYSDATE not null,
  blocksize     NUMBER(6) default 1024 not null,
  con_compress  NUMBER,
  compress_size NUMBER(10)
)
;
comment on table FILEHEADER
  is 'Хранимые файлы';
comment on column FILEHEADER.id
  is 'Ключ';
comment on column FILEHEADER.filename
  is 'Название файла';
comment on column FILEHEADER.filesize
  is 'Размер файла';
comment on column FILEHEADER.filedate
  is 'Дата модификации';
comment on column FILEHEADER.blocksize
  is 'Размер блока';
comment on column FILEHEADER.con_compress
  is 'Тип компрессии';
comment on column FILEHEADER.compress_size
  is 'Размер после компрессии';
create unique index UI_FILEHEDER_UPPER_NAME on FILEHEADER (UPPER(FILENAME));
alter table FILEHEADER
  add constraint PK_FILEHEADER primary key (ID);
grant select on FILEHEADER to F_SMART_RO_ROLE;
grant select, insert, update, delete on FILEHEADER to F_SMART_RW_ROLE;

prompt

prompt Creating table FILEHISTORY
prompt ==========================
prompt

create table FILEHISTORY
(
  filename     VARCHAR2(2000) not null,
  filesize     NUMBER(10) not null,
  filedate     DATE default SYSDATE not null,
  blocksize    NUMBER(6) not null,
  con_compress NUMBER default 0,
  user_name    VARCHAR2(30) default USER not null,
  operation    VARCHAR2(1) not null
)
;
comment on table FILEHISTORY
  is 'Лог модификации "виртулаьной файловой системы"';
comment on column FILEHISTORY.filename
  is 'Название файла';
comment on column FILEHISTORY.filesize
  is 'Размер файла';
comment on column FILEHISTORY.filedate
  is 'Дата модификации';
comment on column FILEHISTORY.blocksize
  is 'Размер блока';
comment on column FILEHISTORY.con_compress
  is 'Тип сжатия';
comment on column FILEHISTORY.user_name
  is 'Пользователь';
comment on column FILEHISTORY.operation
  is 'I,D,U';
alter table FILEHISTORY
  add constraint UK_FILEHISTORY unique (FILENAME, FILEDATE);
grant select on FILEHISTORY to F_SMART_RO_ROLE;

prompt

prompt Creating table FILEITEMS
prompt ========================
prompt

create table FILEITEMS
(
  fileheader_id NUMBER not null,
  item          BLOB not null,
  item_number   NUMBER(6) not null
)
;
comment on table FILEITEMS
  is 'Блоки "виртуальной файловой системы" хранят новые версии приложений и любые другие
файлы';
comment on column FILEITEMS.fileheader_id
  is 'Ссылка на файл';
comment on column FILEITEMS.item
  is 'Кусок файла';
comment on column FILEITEMS.item_number
  is 'Позиция куска';
create index I_FILEHEAEDR_ID on FILEITEMS (FILEHEADER_ID);
alter table FILEITEMS
  add constraint FK_FILEHEADER_ID foreign key (FILEHEADER_ID)
  references FILEHEADER (ID) on delete cascade;
grant select on FILEITEMS to F_SMART_RO_ROLE;
grant select, insert, update, delete on FILEITEMS to F_SMART_RW_ROLE;

prompt

prompt Creating table FILTERS_TREE
prompt ===========================
prompt

create table FILTERS_TREE
(
  id        NUMBER not null,
  filter_id NUMBER,
  user_name VARCHAR2(30),
  name      VARCHAR2(100),
  pmname    VARCHAR2(2000) not null
)
;
comment on table FILTERS_TREE
  is 'Элементы дерва сохраняемых фильтров';
comment on column FILTERS_TREE.id
  is 'ID';
comment on column FILTERS_TREE.filter_id
  is 'Ссылка на родителя';
comment on column FILTERS_TREE.user_name
  is 'Имя пользователя-владельца фильтров';
comment on column FILTERS_TREE.name
  is 'Название ветки в дереве';
comment on column FILTERS_TREE.pmname
  is 'Путь к форме PresetManager''а';
create index I_FK_FILTERS_TREE on FILTERS_TREE (FILTER_ID);
create index I_FK_FILTERS_TREE_PNAME on FILTERS_TREE (PMNAME);
alter table FILTERS_TREE
  add constraint PK_FILTERS_TREE primary key (ID);
alter table FILTERS_TREE
  add constraint U_FILTERS_TREE unique (USER_NAME, NAME, PMNAME, FILTER_ID);
alter table FILTERS_TREE
  add constraint FK_FILTERS_TREE foreign key (FILTER_ID)
  references FILTERS_TREE (ID) on delete cascade;
grant select, insert, update, delete on FILTERS_TREE to F_SMART_RO_ROLE;

prompt

prompt Creating table FILTERS_ITEMS
prompt ============================
prompt

create table FILTERS_ITEMS
(
  id             NUMBER not null,
  filter_tree_id NUMBER not null,
  name           VARCHAR2(50),
  type           NUMBER not null,
  text           BLOB
)
;
comment on table FILTERS_ITEMS
  is 'Элементы фильтров';
comment on column FILTERS_ITEMS.id
  is 'ID';
comment on column FILTERS_ITEMS.filter_tree_id
  is 'Родительская папка';
comment on column FILTERS_ITEMS.name
  is 'Наименование фильтра';
comment on column FILTERS_ITEMS.type
  is 'Тип фильтра';
comment on column FILTERS_ITEMS.text
  is 'Значение';
alter table FILTERS_ITEMS
  add constraint PK_FILTERS_ITEMS primary key (ID);
alter table FILTERS_ITEMS
  add constraint U_FILTERS_ITEMS unique (FILTER_TREE_ID, NAME);
alter table FILTERS_ITEMS
  add constraint FK_FILTERS_ITEMS_FILTERS_TREE foreign key (FILTER_TREE_ID)
  references FILTERS_TREE (ID) on delete cascade;
grant select, insert, update, delete on FILTERS_ITEMS to F_SMART_RO_ROLE;

prompt

prompt Creating table PLAN_TABLE
prompt =========================
prompt

create table PLAN_TABLE
(
  statement_id      VARCHAR2(30),
  plan_id           NUMBER,
  timestamp         DATE,
  remarks           VARCHAR2(4000),
  operation         VARCHAR2(30),
  options           VARCHAR2(255),
  object_node       VARCHAR2(128),
  object_owner      VARCHAR2(30),
  object_name       VARCHAR2(30),
  object_alias      VARCHAR2(65),
  object_instance   INTEGER,
  object_type       VARCHAR2(30),
  optimizer         VARCHAR2(255),
  search_columns    NUMBER,
  id                INTEGER,
  parent_id         INTEGER,
  depth             INTEGER,
  position          INTEGER,
  cost              INTEGER,
  cardinality       INTEGER,
  bytes             INTEGER,
  other_tag         VARCHAR2(255),
  partition_start   VARCHAR2(255),
  partition_stop    VARCHAR2(255),
  partition_id      INTEGER,
  other             LONG,
  distribution      VARCHAR2(30),
  cpu_cost          INTEGER,
  io_cost           INTEGER,
  temp_space        INTEGER,
  access_predicates VARCHAR2(4000),
  filter_predicates VARCHAR2(4000),
  projection        VARCHAR2(4000),
  time              INTEGER,
  qblock_name       VARCHAR2(30)
)
;

prompt

prompt Creating table SMART_AUDIT_APP
prompt ==============================
prompt

create table SMART_AUDIT_APP
(
  appcode                NUMBER not null,
  note                   VARCHAR2(100),
  name                   VARCHAR2(50),
  exename                VARCHAR2(50),
  lastbuild              NUMBER default 0 not null,
  tree_number            NUMBER,
  min_valid_build        NUMBER,
  icon_index             NUMBER,
  delay_sql_trace        NUMBER default 0,
  image                  BLOB,
  base_role              VARCHAR2(50),
  start_tree_group_field VARCHAR2(50),
  alter_script           VARCHAR2(2000)
)
;
comment on table SMART_AUDIT_APP
  is 'PPA_AUDIT_APP';
comment on column SMART_AUDIT_APP.appcode
  is 'код проги';
comment on column SMART_AUDIT_APP.note
  is 'Причечание';
comment on column SMART_AUDIT_APP.name
  is 'название проги';
comment on column SMART_AUDIT_APP.exename
  is 'имя файла';
comment on column SMART_AUDIT_APP.lastbuild
  is 'номер актуального билда';
comment on column SMART_AUDIT_APP.tree_number
  is 'Номер дерева групп';
comment on column SMART_AUDIT_APP.min_valid_build
  is 'Минимальный билд разрешения (для отключения старых приложений)';
comment on column SMART_AUDIT_APP.icon_index
  is 'Индекс иконки';
comment on column SMART_AUDIT_APP.delay_sql_trace
  is 'Предел задержки в секндах по активации трассировки';
comment on column SMART_AUDIT_APP.image
  is 'Иконка приложения';
comment on column SMART_AUDIT_APP.base_role
  is 'Базовая роль необходимая для запуска приложения';
comment on column SMART_AUDIT_APP.start_tree_group_field
  is 'Стартовое поле для запуска модулей XState';
comment on column SMART_AUDIT_APP.alter_script
  is 'Стартовый скрипт для модуля (Alter session и т.д.)';
alter table SMART_AUDIT_APP
  add constraint PK_PPA_AUDIT_APP primary key (APPCODE);
grant select on SMART_AUDIT_APP to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_AUDIT_APP to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_AUDIT_APPLOG
prompt =================================
prompt

create table SMART_AUDIT_APPLOG
(
  id         NUMBER not null,
  appcode    NUMBER,
  curbuild   NUMBER,
  startdate  DATE default SYSDATE not null,
  shutdate   DATE,
  mac        VARCHAR2(50),
  hostname   VARCHAR2(50),
  ip         VARCHAR2(16) not null,
  username   VARCHAR2(50) default USER not null,
  osversion  VARCHAR2(50),
  returncode NUMBER
)
;
comment on table SMART_AUDIT_APPLOG
  is 'Лог активации модулей';
comment on column SMART_AUDIT_APPLOG.id
  is 'ID';
comment on column SMART_AUDIT_APPLOG.appcode
  is 'Код приложения';
comment on column SMART_AUDIT_APPLOG.curbuild
  is 'Номер билда';
comment on column SMART_AUDIT_APPLOG.startdate
  is 'Дата старта приложения';
comment on column SMART_AUDIT_APPLOG.shutdate
  is 'Дата закрытия приложения';
comment on column SMART_AUDIT_APPLOG.mac
  is 'MAC-адрес';
comment on column SMART_AUDIT_APPLOG.hostname
  is 'Хост';
comment on column SMART_AUDIT_APPLOG.ip
  is 'IP адрес';
comment on column SMART_AUDIT_APPLOG.username
  is 'Пользователь';
comment on column SMART_AUDIT_APPLOG.osversion
  is 'Версия ОС';
comment on column SMART_AUDIT_APPLOG.returncode
  is 'Код возврата';
create index I_STARTDATE_AUDIT_APPLOG on SMART_AUDIT_APPLOG (STARTDATE);
alter table SMART_AUDIT_APPLOG
  add constraint PK_PPA_AUDIT_APPLOG primary key (ID);
grant select on SMART_AUDIT_APPLOG to F_SMART_RO_ROLE;
grant select, insert on SMART_AUDIT_APPLOG to PSA_LINK_ROLE;

prompt

prompt Creating table SMART_AUDIT_CONFIG
prompt =================================
prompt

create table SMART_AUDIT_CONFIG
(
  look_schemes         VARCHAR2(2000) not null,
  admin_email          VARCHAR2(2000) not null,
  instance_name        VARCHAR2(30) not null,
  work_schema          VARCHAR2(30) not null,
  about                VARCHAR2(50) not null,
  support_email        VARCHAR2(2000),
  unknown_instance_msg VARCHAR2(2000),
  support_mailhost     VARCHAR2(50),
  error_mailhost       VARCHAR2(50),
  update_help_text     VARCHAR2(4000),
  alter_session        VARCHAR2(4000)
)
;
comment on table SMART_AUDIT_CONFIG
  is 'Таблица конфигурации движка';
comment on column SMART_AUDIT_CONFIG.look_schemes
  is 'Схемы используемые для просмотра парсером (не используется)';
comment on column SMART_AUDIT_CONFIG.admin_email
  is 'Почта администратора системы';
comment on column SMART_AUDIT_CONFIG.instance_name
  is 'Имя экземпляра';
comment on column SMART_AUDIT_CONFIG.work_schema
  is 'Имя рабочей схемы для ALTER SESSION CURRENT_SHEMA';
comment on column SMART_AUDIT_CONFIG.about
  is 'О программе';
comment on column SMART_AUDIT_CONFIG.support_email
  is 'Почта поддержки';
comment on column SMART_AUDIT_CONFIG.unknown_instance_msg
  is 'Ошибка';
comment on column SMART_AUDIT_CONFIG.support_mailhost
  is 'Хост';
comment on column SMART_AUDIT_CONFIG.error_mailhost
  is 'localhost';
comment on column SMART_AUDIT_CONFIG.update_help_text
  is 'Сообщение при обновлении';
comment on column SMART_AUDIT_CONFIG.alter_session
  is 'Глобальный alter session при старте приложений';
alter table SMART_AUDIT_CONFIG
  add constraint PK_SMART_AUDIT_CONFIG primary key (INSTANCE_NAME);
grant select on SMART_AUDIT_CONFIG to F_SMART_RO_ROLE;

prompt

prompt Creating table SMART_AUDIT_EXCEPTIONS_LOG
prompt =========================================
prompt

create table SMART_AUDIT_EXCEPTIONS_LOG
(
  id                  NUMBER not null,
  errormessage        VARCHAR2(4000),
  sizepicture         NUMBER not null,
  subj                VARCHAR2(4000),
  date_event          DATE default SYSDATE not null,
  ppa_audit_applog_id NUMBER,
  con_user_action     NUMBER default 0 not null
)
;
comment on table SMART_AUDIT_EXCEPTIONS_LOG
  is 'Лог проблем на клиентской стороне';
comment on column SMART_AUDIT_EXCEPTIONS_LOG.id
  is 'PK';
comment on column SMART_AUDIT_EXCEPTIONS_LOG.errormessage
  is 'Размер картинки';
comment on column SMART_AUDIT_EXCEPTIONS_LOG.sizepicture
  is 'Тема';
comment on column SMART_AUDIT_EXCEPTIONS_LOG.subj
  is 'Дата события';
comment on column SMART_AUDIT_EXCEPTIONS_LOG.date_event
  is 'Ссылка на лог-сессий';
comment on column SMART_AUDIT_EXCEPTIONS_LOG.ppa_audit_applog_id
  is 'Сообщение';
comment on column SMART_AUDIT_EXCEPTIONS_LOG.con_user_action
  is '0-запись ошибки, 1-запись скриншота, 2-разрешение удаленного доступа';
create index I_PPA_AUDIT_APPLOG_ID on SMART_AUDIT_EXCEPTIONS_LOG (PPA_AUDIT_APPLOG_ID);
alter table SMART_AUDIT_EXCEPTIONS_LOG
  add constraint PK_PPA_AUDIT_APPLOG_ID primary key (ID);
alter table SMART_AUDIT_EXCEPTIONS_LOG
  add constraint FK_PPA_AUDIT_APPLOG_ID foreign key (PPA_AUDIT_APPLOG_ID)
  references SMART_AUDIT_APPLOG (ID) on delete cascade;
grant select, insert on SMART_AUDIT_EXCEPTIONS_LOG to F_SMART_RO_ROLE;
grant delete on SMART_AUDIT_EXCEPTIONS_LOG to F_SMART_RW_ROLE;
grant select, insert on SMART_AUDIT_EXCEPTIONS_LOG to PSA_LINK_ROLE;

prompt

prompt Creating table SMART_AUDIT_HISTORY
prompt ==================================
prompt

create table SMART_AUDIT_HISTORY
(
  ppa_audit_app_id NUMBER not null,
  build            NUMBER not null,
  date_log         DATE default sysdate not null,
  note_text        VARCHAR2(4000),
  size_exe         NUMBER
)
;
comment on table SMART_AUDIT_HISTORY
  is 'Лог изменений программного обеспечения';
comment on column SMART_AUDIT_HISTORY.ppa_audit_app_id
  is 'Внешний ключ на приложение';
comment on column SMART_AUDIT_HISTORY.build
  is 'Номер сборки';
comment on column SMART_AUDIT_HISTORY.date_log
  is '! не используется, удалить ';
comment on column SMART_AUDIT_HISTORY.note_text
  is 'Текст поясняющий изменения';
comment on column SMART_AUDIT_HISTORY.size_exe
  is '! не используется, удалить ';
create index I_PPA_AUDIT_HISTORY_APP_ID on SMART_AUDIT_HISTORY (PPA_AUDIT_APP_ID);
alter table SMART_AUDIT_HISTORY
  add constraint UK_SMART_AUDIT_HISTORY unique (PPA_AUDIT_APP_ID, BUILD);
grant select on SMART_AUDIT_HISTORY to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_AUDIT_HISTORY to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_AUDIT_ROLE
prompt ===============================
prompt

create table SMART_AUDIT_ROLE
(
  appcode      NUMBER not null,
  role_name    VARCHAR2(32) not null,
  role_desc    VARCHAR2(200),
  level_access NUMBER
)
;
comment on table SMART_AUDIT_ROLE
  is 'Роли для приложений';
comment on column SMART_AUDIT_ROLE.appcode
  is 'Код приложения';
comment on column SMART_AUDIT_ROLE.role_name
  is 'Роль';
comment on column SMART_AUDIT_ROLE.role_desc
  is 'Описание';
comment on column SMART_AUDIT_ROLE.level_access
  is 'Уровень доступа';
create unique index IU_SMART_AUDIT_ROLE_SM_ID on SMART_AUDIT_ROLE (APPCODE, ROLE_NAME);
alter table SMART_AUDIT_ROLE
  add constraint FK_SMART_AUDIT_ROLE_APP_CODE foreign key (APPCODE)
  references SMART_AUDIT_APP (APPCODE);
grant select, insert, update, delete on SMART_AUDIT_ROLE to F_SMART_GRANT_ROLE;
grant select on SMART_AUDIT_ROLE to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_AUDIT_ROLE to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_AUDIT_SCREENSHOT
prompt =====================================
prompt

create table SMART_AUDIT_SCREENSHOT
(
  screenshot                 BLOB,
  ppa_audit_exeptions_log_id NUMBER not null
)
;
comment on table SMART_AUDIT_SCREENSHOT
  is 'Скрин при возникновении исключения ';
comment on column SMART_AUDIT_SCREENSHOT.screenshot
  is 'Снимок экрана';
comment on column SMART_AUDIT_SCREENSHOT.ppa_audit_exeptions_log_id
  is 'Ссылка на идентификатор ошибки';
create index I_FK_PPA_AUDIT_EXEPTIONS_LOG on SMART_AUDIT_SCREENSHOT (PPA_AUDIT_EXEPTIONS_LOG_ID);
alter table SMART_AUDIT_SCREENSHOT
  add constraint FK_PPA_AUDIT_EXEPTIONS_LOG_ID foreign key (PPA_AUDIT_EXEPTIONS_LOG_ID)
  references SMART_AUDIT_EXCEPTIONS_LOG (ID) on delete cascade;
grant select, insert on SMART_AUDIT_SCREENSHOT to F_SMART_RO_ROLE;
grant select on SMART_AUDIT_SCREENSHOT to PSA;
grant select, insert on SMART_AUDIT_SCREENSHOT to PSA_LINK_ROLE;

prompt

prompt Creating table SMART_DICS_TRANS
prompt ===============================
prompt

create table SMART_DICS_TRANS
(
  num    NUMBER not null,
  p_type NUMBER not null,
  p_num  NUMBER not null,
  p_id   NUMBER not null,
  c_type NUMBER not null,
  c_num  NUMBER not null,
  c_id   NUMBER not null
)
;
comment on table SMART_DICS_TRANS
  is 'Связи между справочниками';
comment on column SMART_DICS_TRANS.num
  is 'Номер связи';
comment on column SMART_DICS_TRANS.p_type
  is 'Тип справочника';
comment on column SMART_DICS_TRANS.p_num
  is 'Номер справочника';
comment on column SMART_DICS_TRANS.p_id
  is 'Номер строки в справочнике';
comment on column SMART_DICS_TRANS.c_type
  is 'Тип справочника';
comment on column SMART_DICS_TRANS.c_num
  is 'Номер справочника';
comment on column SMART_DICS_TRANS.c_id
  is 'Номер строки в справочнике';
create unique index UI_SMART_DICS_TRANS on SMART_DICS_TRANS (NUM, P_TYPE, P_NUM, P_ID, C_TYPE, C_NUM, C_ID);
grant select on SMART_DICS_TRANS to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_DICS_TRANS to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_DSET_AUDIT
prompt ===============================
prompt

create table SMART_DSET_AUDIT
(
  ppa_audit_applog_id NUMBER,
  smart_dset_id       NUMBER not null,
  date_event          DATE default sysdate not null
)
;
comment on table SMART_DSET_AUDIT
  is 'Аудит активизации наборов данных';
comment on column SMART_DSET_AUDIT.ppa_audit_applog_id
  is 'Ссылка на лог запуска модуля';
comment on column SMART_DSET_AUDIT.smart_dset_id
  is 'Ccылка на набор данных';
comment on column SMART_DSET_AUDIT.date_event
  is 'Дата';
create index I_FK_SMART_DSET_AUDIT_APP_LOG on SMART_DSET_AUDIT (PPA_AUDIT_APPLOG_ID);
create index I_FK_SMART_DSET_AUDIT_SDS_ID on SMART_DSET_AUDIT (SMART_DSET_ID);
alter table SMART_DSET_AUDIT
  add constraint FK_SMART_DSET_AUDIT_APP_LOG foreign key (PPA_AUDIT_APPLOG_ID)
  references SMART_AUDIT_APPLOG (ID) on delete cascade;
alter table SMART_DSET_AUDIT
  add constraint FK_SMART_DSET_AUDIT_SDS_ID foreign key (SMART_DSET_ID)
  references SMART_DSET (ID) on delete cascade;
grant select on SMART_DSET_AUDIT to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_DSET_AUDIT to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_DSET_AUDIT_DETAIL
prompt ======================================
prompt

create table SMART_DSET_AUDIT_DETAIL
(
  ppa_audit_applog_id NUMBER not null,
  smart_dset_id       NUMBER,
  date_event          DATE default sysdate not null,
  exec_sql            CLOB,
  action_name         VARCHAR2(4000) not null,
  id                  NUMBER not null,
  date_event_end      DATE,
  smart_class_id      NUMBER
)
;
comment on table SMART_DSET_AUDIT_DETAIL
  is 'Аудит действий с набором';
comment on column SMART_DSET_AUDIT_DETAIL.ppa_audit_applog_id
  is 'Ссылка на лог запуска модуля';
comment on column SMART_DSET_AUDIT_DETAIL.smart_dset_id
  is 'Ссылка на набор данных';
comment on column SMART_DSET_AUDIT_DETAIL.date_event
  is 'Начало события';
comment on column SMART_DSET_AUDIT_DETAIL.exec_sql
  is 'SQL';
comment on column SMART_DSET_AUDIT_DETAIL.action_name
  is 'Наименование события';
comment on column SMART_DSET_AUDIT_DETAIL.id
  is 'ID';
comment on column SMART_DSET_AUDIT_DETAIL.date_event_end
  is 'Окончание события';
comment on column SMART_DSET_AUDIT_DETAIL.smart_class_id
  is 'ID_Структура композитного набора';
create index I_FK_SD_A_DETAIL_APP_LOG_SD_ID on SMART_DSET_AUDIT_DETAIL (SMART_DSET_ID, PPA_AUDIT_APPLOG_ID);
create index I_FK_SD_AUDIT_DETAIL_APP_LOG on SMART_DSET_AUDIT_DETAIL (PPA_AUDIT_APPLOG_ID);
create index I_SD_AUDIT_DETAIL_CLASS_ID on SMART_DSET_AUDIT_DETAIL (SMART_CLASS_ID);
create index I_SD_AUDIT_DETAIL_DSET_ID on SMART_DSET_AUDIT_DETAIL (SMART_DSET_ID);
alter table SMART_DSET_AUDIT_DETAIL
  add constraint PK_SMART_DSET_AUDIT_DETAIL primary key (ID);
alter table SMART_DSET_AUDIT_DETAIL
  add constraint FK_SD_AUDIT_DETAIL_APP_LOG foreign key (PPA_AUDIT_APPLOG_ID)
  references SMART_AUDIT_APPLOG (ID) on delete cascade;
alter table SMART_DSET_AUDIT_DETAIL
  add constraint FK_SD_AUDIT_DETAIL_CLASS_ID foreign key (SMART_CLASS_ID)
  references SMART_CLASS (ID) on delete cascade;
alter table SMART_DSET_AUDIT_DETAIL
  add constraint FK_SD_AUDIT_DETAIL_SDS_ID foreign key (SMART_DSET_ID)
  references SMART_DSET (ID) on delete cascade;
grant select, insert, update on SMART_DSET_AUDIT_DETAIL to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_DSET_AUDIT_DETAIL to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_GRANT
prompt ==========================
prompt

create table SMART_GRANT
(
  appcode        NUMBER not null,
  filter         VARCHAR2(200) default '-' not null,
  enabled        NUMBER default 1 not null,
  con_type_check NUMBER not null,
  first_start    DATE default sysdate not null,
  count_start    NUMBER default 1 not null
)
;
comment on table SMART_GRANT
  is 'Права на запуск';
comment on column SMART_GRANT.appcode
  is 'номер приложения';
comment on column SMART_GRANT.filter
  is 'фильтр';
comment on column SMART_GRANT.enabled
  is 'доступ (0 - запрещен, 1-разрешен)';
comment on column SMART_GRANT.con_type_check
  is 'CON-157 проверка по 1-IP, 2 - username, 3 hostname';
comment on column SMART_GRANT.first_start
  is 'Дата первого старта';
comment on column SMART_GRANT.count_start
  is 'Колличество запусков';
create unique index IU_SMART_GRANT on SMART_GRANT (APPCODE, CON_TYPE_CHECK, FILTER);
alter table SMART_GRANT
  add constraint UK_SMART_GRANT unique (APPCODE, FILTER, CON_TYPE_CHECK);
grant select on SMART_GRANT to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_GRANT to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_GRANT_MENU
prompt ===============================
prompt

create table SMART_GRANT_MENU
(
  user_name     VARCHAR2(30) not null,
  smart_dset_id NUMBER not null,
  con_type      NUMBER default 1 not null
)
;
comment on table SMART_GRANT_MENU
  is 'Список пользователей, которым разрешены встроенные наборы в меню';
comment on column SMART_GRANT_MENU.user_name
  is 'Имя пользователя';
comment on column SMART_GRANT_MENU.smart_dset_id
  is 'ID_Пользовательского набора';
comment on column SMART_GRANT_MENU.con_type
  is 'Вид гранта 1 для менюшки 2 для набора данных Smart';
create index I_SMART_GRANT_MENU_DSET_ID on SMART_GRANT_MENU (SMART_DSET_ID);
create index I_SMART_GRANT_MENU_USER on SMART_GRANT_MENU (USER_NAME);
alter table SMART_GRANT_MENU
  add constraint UK_SMART_GRANT_MENU unique (USER_NAME, SMART_DSET_ID, CON_TYPE);
alter table SMART_GRANT_MENU
  add constraint FK_SMART_GRANT_MENU_DSET_ID foreign key (SMART_DSET_ID)
  references SMART_DSET (ID) on delete cascade;
grant select, insert, update, delete on SMART_GRANT_MENU to F_SMART_GRANT_ROLE;
grant select on SMART_GRANT_MENU to F_SMART_RO_ROLE;

prompt

prompt Creating table SMART_GRANT_ROLES
prompt ================================
prompt

create table SMART_GRANT_ROLES
(
  smart_dset_id NUMBER not null,
  role_name     VARCHAR2(100) not null
)
;
comment on table SMART_GRANT_ROLES
  is 'Список ролей для наборов';
comment on column SMART_GRANT_ROLES.smart_dset_id
  is 'ID_SDS наборы данных';
comment on column SMART_GRANT_ROLES.role_name
  is 'Наименование роли';
create unique index IU_SMART_GRANT_ROLES_SM_ID on SMART_GRANT_ROLES (SMART_DSET_ID, ROLE_NAME);
alter table SMART_GRANT_ROLES
  add constraint FK_SMART_GRANT_ROLES_SM_ID foreign key (SMART_DSET_ID)
  references SMART_DSET (ID) on delete cascade;
grant select, insert, update, delete on SMART_GRANT_ROLES to F_SMART_GRANT_ROLE;
grant select on SMART_GRANT_ROLES to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_GRANT_ROLES to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_MUNDETAIL
prompt ==============================
prompt

create table SMART_MUNDETAIL
(
  smart_dset_id NUMBER not null,
  sort_num      NUMBER not null,
  num_control   NUMBER default 0 not null,
  visibility    NUMBER default 0 not null,
  smart_app_id  NUMBER
)
;
comment on table SMART_MUNDETAIL
  is 'Список пользовательских наборов вкл. в панель детализации';
comment on column SMART_MUNDETAIL.smart_dset_id
  is 'ID_Пользовательского набора';
comment on column SMART_MUNDETAIL.sort_num
  is 'Порядок расположения в панели';
comment on column SMART_MUNDETAIL.num_control
  is 'Номер панели детализации';
comment on column SMART_MUNDETAIL.visibility
  is 'При 1 - Ограничена видимость набора в панели для пользователей';
comment on column SMART_MUNDETAIL.smart_app_id
  is 'ID_Список модулей системы';
create index I_FK_SMART_MUNDETAIL_APP_ID on SMART_MUNDETAIL (SMART_APP_ID);
create unique index I_SMART_MUNDETAIL_SM_NUM on SMART_MUNDETAIL (SMART_DSET_ID, NUM_CONTROL, SMART_APP_ID);
create unique index I_SMART_MUNDETAIL_UNIQUE on SMART_MUNDETAIL (SORT_NUM, NUM_CONTROL, SMART_APP_ID);
alter table SMART_MUNDETAIL
  add constraint FK_SMART_MUNDETAIL_APP_ID foreign key (SMART_APP_ID)
  references SMART_AUDIT_APP (APPCODE) on delete cascade;
alter table SMART_MUNDETAIL
  add constraint FK_SMART_MUNDETAIL_DSET_ID foreign key (SMART_DSET_ID)
  references SMART_DSET (ID);
grant select on SMART_MUNDETAIL to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_MUNDETAIL to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_PANELS
prompt ===========================
prompt

create table SMART_PANELS
(
  app_code NUMBER not null,
  name     VARCHAR2(1000) not null,
  width    NUMBER not null,
  height   NUMBER not null
)
;
comment on table SMART_PANELS
  is 'Размеры панелек';
comment on column SMART_PANELS.app_code
  is 'Код приложения';
comment on column SMART_PANELS.name
  is 'Наименование панельки';
comment on column SMART_PANELS.width
  is 'Ширина';
comment on column SMART_PANELS.height
  is 'Высота';
create unique index IU_APP_PANEL on SMART_PANELS (APP_CODE, NAME);
alter table SMART_PANELS
  add constraint FK_SMART_PANELS foreign key (APP_CODE)
  references SMART_AUDIT_APP (APPCODE) on delete cascade;
grant select on SMART_PANELS to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_PANELS to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_SCRIPT
prompt ===========================
prompt

create table SMART_SCRIPT
(
  id             NUMBER not null,
  smart_class_id NUMBER not null,
  date_history   DATE,
  script         CLOB not null,
  template       BLOB
)
;
comment on table SMART_SCRIPT
  is 'Скрипты';
comment on column SMART_SCRIPT.id
  is 'ID';
comment on column SMART_SCRIPT.smart_class_id
  is 'ID_Пользовательский набор';
comment on column SMART_SCRIPT.date_history
  is 'Дата истории SQL';
comment on column SMART_SCRIPT.script
  is 'Скрипты';
comment on column SMART_SCRIPT.template
  is 'Шаблон для печати';
create index I_SMART_SCRIPT_SMART_CLASS_ID on SMART_SCRIPT (SMART_CLASS_ID);
create unique index IU_SMART_SCRIPT_FAST_CLASS_ID on SMART_SCRIPT (ID, SMART_CLASS_ID);
alter table SMART_SCRIPT
  add constraint PK_SMART_SCRIPT primary key (ID);
alter table SMART_SCRIPT
  add constraint FK_SMART_SCRIPT_FAST_CLASS_ID foreign key (SMART_CLASS_ID)
  references SMART_CLASS (ID) on delete cascade;
grant select on SMART_SCRIPT to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_SCRIPT to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_SETTINGS
prompt =============================
prompt

create table SMART_SETTINGS
(
  id            NUMBER not null,
  object_tag_id NUMBER not null,
  username      VARCHAR2(30) default user not null,
  script        CLOB not null
)
;
comment on table SMART_SETTINGS
  is 'Настройки объектов';
comment on column SMART_SETTINGS.id
  is 'ID';
comment on column SMART_SETTINGS.object_tag_id
  is 'TGA_ID объекта';
comment on column SMART_SETTINGS.username
  is 'Пользователь';
comment on column SMART_SETTINGS.script
  is 'Скрипты';
create index I_SMART_SETTINGS_TAG_ID_USER on SMART_SETTINGS (OBJECT_TAG_ID, USERNAME);
alter table SMART_SETTINGS
  add constraint PK_SMART_SETTINGS primary key (ID);
grant select, insert, update, delete on SMART_SETTINGS to F_SMART_RO_ROLE;

prompt

prompt Creating table SMART_TRANSLATE
prompt ==============================
prompt

create table SMART_TRANSLATE
(
  constraint_name VARCHAR2(100) not null,
  error_message   VARCHAR2(2000) not null
)
;
comment on table SMART_TRANSLATE
  is 'Таблица трансляции сообщении об ошибках';
comment on column SMART_TRANSLATE.constraint_name
  is 'Наименование констрейна';
comment on column SMART_TRANSLATE.error_message
  is 'Сообщение об ошибке';
create unique index IU_SMART_MESSAGES_NAME on SMART_TRANSLATE (CONSTRAINT_NAME);
grant select on SMART_TRANSLATE to F_SMART_RO_ROLE;
grant select, insert, update, delete on SMART_TRANSLATE to F_SMART_RW_ROLE;

prompt

prompt Creating table SMART_TREE_VALUES
prompt ================================
prompt

create global temporary table SMART_TREE_VALUES
(
  tag_id    NUMBER not null,
  value     VARCHAR2(4000) not null,
  vtype     NUMBER not null,
  fieldname VARCHAR2(30) not null
)
on commit preserve rows;
comment on table SMART_TREE_VALUES
  is 'Список временных значений из дерева фильтров';
comment on column SMART_TREE_VALUES.tag_id
  is 'Идентификатор объекта';
comment on column SMART_TREE_VALUES.value
  is 'Значение';
comment on column SMART_TREE_VALUES.vtype
  is 'Тип значения: 1-в списке in(), 2-в списке not in()';
comment on column SMART_TREE_VALUES.fieldname
  is 'Наименование поля';
create index I1_SMART_TREE_VALUES on SMART_TREE_VALUES (VALUE, VTYPE);
grant select, insert, update, delete on SMART_TREE_VALUES to F_SMART_RO_ROLE;

prompt

prompt Creating table TMP_SPRAV_MTH
prompt ============================
prompt

create table TMP_SPRAV_MTH
(
  id         NUMBER,
  name       VARCHAR2(1000),
  sprav_name VARCHAR2(100)
)
;
comment on column TMP_SPRAV_MTH.id
  is 'ИД';
comment on column TMP_SPRAV_MTH.name
  is 'Наименование';
comment on column TMP_SPRAV_MTH.sprav_name
  is 'Наименование справочника';

prompt

prompt Creating table VAR_NAME
prompt =======================
prompt

create table VAR_NAME
(
  name VARCHAR2(100) not null,
  note VARCHAR2(2000) not null
)
;
comment on table VAR_NAME
  is 'Список переменных';
comment on column VAR_NAME.name
  is 'Наименование переменной';
comment on column VAR_NAME.note
  is 'Описание';
alter table VAR_NAME
  add constraint PK_TMP_VAR_NAME primary key (NAME);

prompt

prompt Creating table VAR_VALUE
prompt ========================
prompt

create global temporary table VAR_VALUE
(
  var_name VARCHAR2(100) not null,
  var_str  VARCHAR2(4000),
  var_num  NUMBER,
  var_date DATE
)
on commit preserve rows;
comment on table VAR_VALUE
  is 'Список временных переменных';
comment on column VAR_VALUE.var_name
  is 'Наименование переменной';
comment on column VAR_VALUE.var_str
  is 'Строка';
comment on column VAR_VALUE.var_num
  is 'Число';
comment on column VAR_VALUE.var_date
  is 'Дата';
alter table VAR_VALUE
  add constraint PK_VAR_VALUE primary key (VAR_NAME);

prompt

prompt Creating sequence DICS_SEQ
prompt ==========================
prompt

create sequence DICS_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 20316
increment by 1
cache 2;

prompt

prompt Creating sequence DICS_TREE_ITEM_SEQ
prompt ====================================
prompt

create sequence DICS_TREE_ITEM_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1241
increment by 1
cache 2;

prompt

prompt Creating sequence DICS_TREE_SEQ
prompt ===============================
prompt

create sequence DICS_TREE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 259
increment by 1
cache 2;

prompt

prompt Creating sequence FILEHEADER_SEQ
prompt ================================
prompt

create sequence FILEHEADER_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 343
increment by 1
cache 2;

prompt

prompt Creating sequence FILTERS_ITEM_ID_SEQ
prompt =====================================
prompt

create sequence FILTERS_ITEM_ID_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 2;

prompt

prompt Creating sequence S_AUDIT_GLB
prompt =============================
prompt

create sequence S_AUDIT_GLB
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 2;

prompt

prompt Creating sequence SEQ_AUDIT_GLB
prompt ===============================
prompt

create sequence SEQ_AUDIT_GLB
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 2;

prompt

prompt Creating sequence SMART_AUDIT_APPLOG_SEQ
prompt ========================================
prompt

create sequence SMART_AUDIT_APPLOG_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 720374
increment by 1
cache 2;
grant select on SMART_AUDIT_APPLOG_SEQ to PSA_LINK_ROLE;


prompt

prompt Creating sequence SMART_AUDIT_EXCEPTIONS_LOG_SEQ
prompt ================================================
prompt

create sequence SMART_AUDIT_EXCEPTIONS_LOG_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 71332
increment by 1
cache 2;
grant select on SMART_AUDIT_EXCEPTIONS_LOG_SEQ to PSA_LINK_ROLE;


prompt

prompt Creating sequence SMART_CLASS_SEQ
prompt =================================
prompt

create sequence SMART_CLASS_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 647990
increment by 1
cache 2;

prompt

prompt Creating sequence SMART_DSET_AUDIT_DETAIL_SEQ
prompt =============================================
prompt

create sequence SMART_DSET_AUDIT_DETAIL_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 23948
increment by 1
cache 2;

prompt

prompt Creating sequence SMART_DSET_SEQ
prompt ================================
prompt

create sequence SMART_DSET_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1361
increment by 1
cache 2;

prompt

prompt Creating sequence SMART_LANGUAGE_SEQ
prompt ====================================
prompt

create sequence SMART_LANGUAGE_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 1
increment by 1
cache 2;

prompt

prompt Creating sequence SMART_SCRIPT_SEQ
prompt ==================================
prompt

create sequence SMART_SCRIPT_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 647117
increment by 1
cache 2;

prompt

prompt Creating sequence SMART_SETTINGS_SEQ
prompt ====================================
prompt

create sequence SMART_SETTINGS_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 197
increment by 1
cache 2;

prompt

prompt Creating view V_DICS
prompt ====================
prompt

create or replace view v_dics as
select l.nn as id,
       h.number_act dic,
       psa.pkg_doc_line_utl.get_str_attr(l.site, l.id, 163) name,
       case
         when psa.pkg_doc_line_utl.get_date_attr(l.site, l.id, 166) is null then
          0
         else
          1
       end as invisible,
       0 is_minor,
       psa.pkg_doc_line_utl.get_str_attr(l.site, l.id, 164) abbr,
       psa.pkg_doc_line_utl.get_date_attr(l.site, l.id, 165) date_start,
       psa.pkg_doc_line_utl.get_date_attr(l.site, l.id, 166) date_end,
       h.site
  from psa.doc_header h, psa.doc_line l
 where e_doc_type = 10
   and h.id = l.doc_header_id;
grant select on V_DICS to F_SMART_RO_ROLE;
grant select on V_DICS to PSA;


prompt

prompt Creating view V_SCRAP_USERS_STARTDATE
prompt =====================================
prompt

create or replace view v_scrap_users_startdate as
select '114.000.051' code,
       'ИС "Учет металлолома"' sys_name,
       username logonname,
       startdate ut_date
  from smart_audit_applog;

prompt

prompt Creating function GET_SUBNET_FROM_IP
prompt ====================================
prompt

create or replace function get_subnet_from_ip(p_IP varchar2) return varchar2 is
  l_Result varchar2(100);
begin
    l_Result := case
         -- 172.17.х.х
         when p_IP like '172.17.1.%' or p_IP like '172.17.2.%' or
              p_IP like '172.17.3.%' or p_IP like '172.17.4.%' or
              p_IP like '172.17.6.%' or p_IP like '172.17.7.%' then
          'Комбинатоуправление'
         when p_IP like '172.17.5.%' then
          'ГВЦ'

         -- 172.17.х.х
         when p_IP like '172.18.3.%' then
          'Сбыт'

         -- 192.168.х.х
         when p_IP like '192.168.6.%' then
          'ДИТ'
         when p_IP like '192.168.8.%' or p_IP like '192.168.177.%' then
          'Инж.Центр'
         when p_IP like '192.168.16.%'  or  p_IP like '192.168.116.%' then
          'КЦ-1'
         when p_IP like '192.168.31.%' or p_IP like '192.168.62.%' then
          'Мелкие сетки'
         when p_IP like '192.168.38.%' then
          'Библиотека'
         when p_IP like '192.168.50.%' then
          'Сеть комбината'
         when p_IP like '192.168.60.%' then
          'ЦПП и много другого'
         when p_IP like '192.168.64.%' then
          'Копровый и много другого'
         when p_IP like '192.168.92.%' then
          'Модем'
         when p_IP like '192.168.101.%' or p_IP like '192.168.102.%' then
          'ГВЦ 1 этаж'
         when p_IP like '192.168.114.%' then
          'Ферросплавный цех'
         when p_IP like '192.168.117.%' then
          'КЦ-2'
         when p_IP like '192.168.121.%' then
          'ПТС'
         when p_IP like '192.168.122.%' then
          'ПГП'
         when p_IP like '192.168.123.%' or p_IP like '192.168.28.%' or p_IP like '192.168.18.%' then
          'ПХПП'
         when p_IP like '192.168.125.%' or p_IP like '192.168.126.%' then
          'ПДС'
         when p_IP like '192.168.128.%' then
           'АГП'
         when p_IP like '192.168.143.%' then
           'ОРМЦ'
         when p_IP like '192.168.147.%' then
           'РЦПО-1'
         when p_IP like '192.168.151.%' then
           'ЭРЦ'
         when p_IP like '192.168.153.%' then
           'Центр.лабор.механизации'
         when p_IP like '192.168.156.%' then
           'ЦЗП'
         when p_IP like '192.168.159.%' then
           'Тепловой цех'
         when p_IP like '192.168.192.%' then
           'УТК'
         when p_IP like '192.168.192.%' then
           'ЛОТ'
         when p_IP like '192.168.208.%' then
          'Старое комбинатоуправление'

         -- 81.20.х.х
         when p_IP like '81.20.194.%' or p_IP like '81.20.195.%' then
          'Внешняя сеть'
         end;
  return l_Result;
end get_subnet_from_ip;
/
grant execute on GET_SUBNET_FROM_IP to F_SMART_RO_ROLE;


prompt

prompt Creating view V_SMART_AUDIT_SEARCH
prompt ==================================
prompt

CREATE OR REPLACE VIEW V_SMART_AUDIT_SEARCH AS
SELECT case
         when USERNAME in ('CP','PSA') then
          'Разработчики'
         else
          'Пользователи'
       end USER_GROUP,
       (SELECT COUNT(*)
          FROM SMART_AUDIT_EXCEPTIONS_LOG T
         WHERE T.PPA_AUDIT_APPLOG_ID = L.ID
           AND SIZEPICTURE > 0) AS COUNT_ERROR,
       (SELECT COUNT(*)
          FROM SMART_AUDIT_EXCEPTIONS_LOG T
         WHERE T.PPA_AUDIT_APPLOG_ID = L.ID
           AND SIZEPICTURE = 0) AS COUNT_WARN,
       round((SHUTDATE - STARTDATE) * 60 * 24, 1) as count_mi,
       get_subnet_from_ip(ip) SUBNET,
       P.APPCODE,
       P.EXENAME,
       L.ID,
       L.CURBUILD,
       L.STARTDATE,
       L.SHUTDATE,
       L.MAC,
       L.HOSTNAME,
       L.IP,
       L.USERNAME,
       L.OSVERSION,
       L.RETURNCODE
  FROM SMART_AUDIT_APP P, SMART_AUDIT_APPLOG L
 WHERE L.APPCODE = P.APPCODE;
grant select on V_SMART_AUDIT_SEARCH to F_SMART_RO_ROLE;


prompt

prompt Creating view V_SMART_DSET_AUDIT
prompt ================================
prompt

create or replace view v_smart_dset_audit as
select da.smart_dset_id,
      da.date_event,
      da.ppa_audit_applog_id,
      apl.appcode,
      apl.mac,
      apl.hostname,
      apl.ip,
      apl.username,
      apl.osversion,
      ap.exename,
      get_subnet_from_ip(ip) subnet
from smart_audit_applog apl, smart_dset_audit da, smart_audit_app ap
where apl.id = da.ppa_audit_applog_id and ap.appcode = apl.appcode;
grant select on V_SMART_DSET_AUDIT to F_SMART_RO_ROLE;


prompt

prompt Creating view V_SMART_LOAD_APP
prompt ==============================
prompt

create or replace view v_smart_load_app as
select a.APPCODE,
       a.NOTE,
       a.NAME,
       a.EXENAME,
       a.LASTBUILD,
       a.TREE_NUMBER,
       a.MIN_VALID_BUILD,
       a.ICON_INDEX,
       a.DELAY_SQL_TRACE,
       a.IMAGE,
       a.BASE_ROLE,
       a.START_TREE_GROUP_FIELD,
       a.ALTER_SCRIPT
  from smart_audit_app a
 where a.appcode in (105, /*Отчетные формы*/
                     1300 /*Загрузка транзита УК из Excel*/);
grant select on V_SMART_LOAD_APP to F_SMART_RO_ROLE;


prompt

prompt Creating view V_SMART_USERS
prompt ===========================
prompt

create or replace view v_smart_users as
select username
  from all_users
 where username not in ('SYS',
                        'SYSTEM',
                        'DBSNMP',
                        'PERFSTAT',
                        'DB_MANAGER',
                        'OUTLN',
                        'WMSYS',
                        'ORDSYS',
                        'ORDPLUGINS',
                        'MDSYS',
                        'CTXSYS',
                        'XDB',
                        'ANONYMOUS',
                        'WKSYS',
                        'WKPROXY',
                        'ODM',
                        'ODM_MTR',
                        'LBACSYS',
                        'OLAPSYS',
                        'DMSYS',
                        'DIP',
                        'CAPTAIN',
                        'EXFSYS',
                        'MDDATA',
                        'ORACLE_OCM',
                        'MGMT_VIEW',
                        'SI_INFORMTN_SCHEMA',
                        'SYSMAN',
                        'TSMSYS',
                        'SYSLOG',
                        'TM',
                        'OWBSYS',
                        'APEX_030200',
                        'APEX_PUBLIC_USER',
                        'FLOWS_FILES',
                        'SPATIAL_CSW_ADMIN_USR',
                        'SPATIAL_WFS_ADMIN_USR',
                        'OWBSYS_AUDIT',
                        'ORDDATA',
                        'XS$NULL',
                        'APPQOSSYS');
grant select on V_SMART_USERS to F_SMART_RO_ROLE;


prompt

prompt Creating view V_UTL_MISS_FK_INDEX
prompt =================================
prompt

create or replace view v_utl_miss_fk_index as
select 'create index I_'||constraint_name ||
' on '|| table_name ||' ('||columns ||');' SQL_TXT from (
select table_name, constraint_name,
       cname1 || nvl2(cname2,','||cname2,null) ||
       nvl2(cname3,','||cname3,null) || nvl2(cname4,','||cname4,null) ||
       nvl2(cname5,','||cname5,null) || nvl2(cname6,','||cname6,null) ||
       nvl2(cname7,','||cname7,null) || nvl2(cname8,','||cname8,null)
            columns
  from ( select b.table_name,
                b.constraint_name,
                max(decode( position, 1, column_name, null )) cname1,
                max(decode( position, 2, column_name, null )) cname2,
                max(decode( position, 3, column_name, null )) cname3,
                max(decode( position, 4, column_name, null )) cname4,
                max(decode( position, 5, column_name, null )) cname5,
                max(decode( position, 6, column_name, null )) cname6,
                max(decode( position, 7, column_name, null )) cname7,
                max(decode( position, 8, column_name, null )) cname8,
                count(*) col_cnt
           from (select substr(table_name,1,30) table_name,
                        substr(constraint_name,1,30) constraint_name,
                        substr(column_name,1,30) column_name,
                        position
                   from user_cons_columns ) a,
                user_constraints b
          where a.constraint_name = b.constraint_name
            and b.constraint_type = 'R'
          group by b.table_name, b.constraint_name
       ) cons
 where col_cnt > ALL
         ( select count(*)
             from user_ind_columns i
            where i.table_name = cons.table_name
              and i.column_name in (cname1, cname2, cname3, cname4,
                                    cname5, cname6, cname7, cname8 )
              and i.column_position <= cons.col_cnt
            group by i.index_name
         )
);

prompt

prompt Creating package PKGAUDIT
prompt =========================
prompt

CREATE OR REPLACE PACKAGE PkgAudit is

  -- Author  : PPA
  -- Created : 01.08.2000 16:39:08
  -- Purpose : Audit
  function SendBugReport(v_Subj in varchar2, v_Text in varchar2)
    return integer;
  -- киает поту! + вертает ID - для указания места для скриншотика
  function StopAPP(iDUMMY in integer) return integer;
  function GET_APP_CODE return integer;
  function StartAPP(App_Code     in integer,
                    MAC          in VARCHAR2,
                    HostName     in VARCHAR2,
                    IP           in VARCHAR2,
                    OSVERSION    in VARCHAR2,
                    CURRENTBUILD in VARCHAR2) return integer;
  function GetTreeNumber(iDUMMY in integer) return integer;
  --// Const
  PPAAuditOldBuild   constant integer := 1;
  PPAAuditForbidden  constant integer := 2;
  PPAAuditYouMessage constant integer := 3;

  v_APP_CODE         INTEGER;
  v_CURRENT_AUDIT_ID INTEGER;
  v_NOTE_MESSAGE     VARCHAR(500); --// Пояснительный текст
  v_ERROR_MESSAGE    VARCHAR(500); --// Пояснительный текст ошибки
  v_LASTBUILD        integer;
  v_RETURNCODE       integer;
  v_TREE_NUMBER      integer;
  v_EXENAME          VARCHAR(50);
end PkgAudit;
/
grant execute on PKGAUDIT to F_SMART_RO_ROLE;


prompt

prompt Creating package PKGAUDIT_EMAIL
prompt ===============================
prompt

create or replace package pkgaudit_email is

  -- Author  : GRISHKOV_MN
  -- Created : 10.02.2009 14:14:25
  -- Purpose : Пакет отправки почты

  --Отправка smtp сообщения нескольким пользователям. Разделительные знаки
  --адресов ",", ";"
  procedure multisender(p_msg        varchar2,
                        p_subject    varchar2,
                        p_recipients varchar2);
end pkgaudit_email;
/
grant execute on PKGAUDIT_EMAIL to F_SMART_RO_ROLE;


prompt

prompt Creating type T_ID_ARRAY
prompt ========================
prompt

CREATE OR REPLACE TYPE "T_ID_ARRAY"                                                                              is table of int
/

prompt

prompt Creating package PKGCOMMATEXT
prompt =============================
prompt

create or replace package PkgCommaText is
  -- Author  : PPA
  -- Created : 24.05.04 9:59:23
  -- Purpose : Парсер строки с разделителями
  Type TRow is Record (ValNum  number,
                       ValStr  varchar2(4000),
                       ValDate date);
  Type TTable is Table of TRow;
  function GetID(v_comma_text in varchar2, v_sep in varchar2 := ',')
  return t_id_array;
  --grishkov_mn 14.05.2010 (Парсер разных типов)
  --p_type = 1 - number,
        -- = 2 - varcha2
        -- = 3 - date
  function GetTable(p_commatext  varchar2,
                    p_sep_symbol varchar2,
                    p_type       number,
                    p_date_mask  varchar2 := null) return TTable PIPELINED;
  --grishkov_mn 14.05.2010 (Парсер разных типов с соблюдением уникальности)
  --p_type = 1 - number,
        -- = 2 - varcha2
        -- = 3 - date
  function GetUniqueTable(p_commatext  varchar2,
                          p_sep_symbol varchar2,
                          p_type       number,
                          p_date_mask  varchar2 := null) return TTable PIPELINED;
end PkgCommaText;
/

prompt

prompt Creating package PKG_CONST
prompt ==========================
prompt

create or replace package PKG_CONST is

  -- Author  : GRISHKOV_MN
  -- Created : 23.06.2010 22:47:49
  -- Purpose : Получение констант

  --Получить значение число
  function get_const_num(p_const_name varchar2) return number;

  --Получить значение строка
  function get_const_str(p_const_name varchar2) return varchar2;

  --Получить значение дата
  function get_const_date(p_const_name varchar2) return date;

end PKG_CONST;
/

prompt

prompt Creating package PKGDICS
prompt ========================
prompt

CREATE OR REPLACE PACKAGE PkgDics as
  function Add(DICIN in NUMBER, NAMEIN in VARCHAR2) return integer;
  function ndic(v_ID in integer) return varchar2;
  function ncon(v_ID in integer, v_DIC in integer) return varchar2;
  function ne(v_ID in integer, v_DIC in integer, isAbbr in integer default 0) return varchar2;
end PkgDics;
/


prompt

prompt Creating package PKGFILESTORAGE
prompt ===============================
prompt

create or replace package PKGFILESTORAGE as

  -- Author  : KRANK
  -- Created : 22.07.2003 16:23:00
  -- Purpose : Сохранение файлов в БД
  v_mutex boolean;
  procedure CheckGrant;
  procedure DeleteFile(v_Name in varchar2);
end PKGFILESTORAGE;
/
grant execute on PKGFILESTORAGE to F_SMART_RO_ROLE;


prompt

prompt Creating package PKGFILTERSTREE
prompt ===============================
prompt

create or replace package PKGFILTERSTREE is
  -- Author  : IK
  -- Created : 05.07.2002 22:42:46
  -- возвратим "нужный" ID HKEY_CURRENT_USER
  function GetRegKey(p_filter_tree_id in number) return varchar2;
  procedure ClearUserFilters(p_PMName in varchar2);
end PKGFILTERSTREE;
/
grant execute on PKGFILTERSTREE to F_SMART_RO_ROLE;


prompt

prompt Creating package PKGSMARTFIELDS
prompt ===============================
prompt

create or replace package PkgSmartFields is
  --для аналитики
  function VarType return number;
  function VarBeginValue return varchar2;
  function VarEndValue return varchar2;
  function VarOneFieldName return varchar2;
  function VarTwoFieldName return varchar2;
  procedure SetAnalyticValue(p_Type         in number,
                             p_BeginValue   in varchar2,
                             p_EndValue     in varchar2,
                             p_OneFieldName in varchar2,
                             p_TwoFieldName in varchar2);
  --
  function AdminUsers return number;
  function GetRegKey(p_filter_tree_id in number) return varchar2;
  procedure AuditOpenSDS(p_ppa_audit_applog_id in number,
                         p_id                  in number,
                         p_is_new              in number := 0);
  function DetailAuditOpenSDS(p_ppa_audit_applog_id in number,
                              p_id                  in number,
                              p_EXEC_SQL            in clob,
                              p_ACTION_NAME         in varchar2,
                              p_upd_id              in integer,
                              p_is_new              in number := 0)
    return integer;
  procedure DicFilterNameSort(v_dic_tree_id in int);
  function CopyReport(p_ClassID in number,
                      p_FK_ID   in number,
                      p_Name    in varchar2) return number;
  function GetIntervalScript(p_class_id in number, p_user in varchar2)
    return clob;
  function GetIntervalLabel(p_begin_value in varchar2,
                            p_end_value   in varchar2,
                            p_lookup_type in number,
                            p_lookup_num  in number) return varchar2;
  function GetIntervalField(p_begin_value in varchar2,
                            p_end_value   in varchar2,
                            p_lookup_type in number,
                            p_data_type   in number,
                            p_field_name  in varchar2) return varchar2;
  function CreateClass(p_Name     in varchar2,
                       p_ListID   in number,
                       p_ParentID in number,
                       p_Type     in number,
                       p_SortNum  in number := null,
                       p_ObjID    in number := null) return integer;
  procedure DeleteClass(p_ID in number);
  procedure SetScript(p_ClassID in number,
                      p_Script  in clob,
                      p_Date    in date := null);
  procedure UpdScript(p_ClassID in number,
                      p_Script  in clob,
                      p_History in number := 0);
end PkgSmartFields;
/
grant execute on PKGSMARTFIELDS to F_SMART_RO_ROLE;
grant execute on PKGSMARTFIELDS to F_SMART_RW_ROLE;


prompt

prompt Creating package PKG_VARIABLE
prompt =============================
prompt

create or replace package PKG_VARIABLE as
  --
  procedure set_var_str(p_var_name in varchar2, p_value in varchar2);
  procedure set_var_num(p_var_name in varchar2, p_value in number);
  procedure set_var_date(p_var_name in varchar2, p_value in date);
  procedure clear_var(p_var_name in varchar2);

  procedure inc(p_var_name in varchar2);
  procedure dec(p_var_name in varchar2);

  function get_var_str(p_var_name in varchar2) return varchar2;
  function get_var_num(p_var_name in varchar2) return number;
  function get_var_date(p_var_name in varchar2) return date;

  function get_var_str_silent(p_var_name in varchar2) return varchar2;
  function get_var_num_silent(p_var_name in varchar2) return number;
  function get_var_date_silent(p_var_name in varchar2) return date;

  procedure create_var(p_var_name varchar2, p_var_note varchar2);
  procedure delete_var(p_var_name varchar2);
  --
end PKG_VARIABLE;
/
grant execute on PKG_VARIABLE to F_SMART_RO_ROLE;
grant execute on PKG_VARIABLE to PSA;
grant execute on PKG_VARIABLE to PSA_RO_ROLE;


prompt

prompt Creating type SYS_PLSQL_52186_DUMMY_2
prompt =====================================
prompt

create or replace type SYS_PLSQL_52186_DUMMY_2 as table of number;
/

prompt

prompt Creating type SYS_PLSQL_52186_9_2
prompt =================================
prompt

create or replace type SYS_PLSQL_52186_9_2 as object (VALNUM NUMBER,
VALSTR VARCHAR2(4000),
VALDATE DATE);
/

prompt

prompt Creating type SYS_PLSQL_52186_29_2
prompt ==================================
prompt

create or replace type SYS_PLSQL_52186_29_2 as table of CP."SYS_PLSQL_52186_9_2";
/

prompt

prompt Creating type SYS_PLSQL_52557_DUMMY_1
prompt =====================================
prompt

CREATE OR REPLACE TYPE "SYS_PLSQL_52557_DUMMY_1"                                                                             as table of number;
/

prompt

prompt Creating type SYS_PLSQL_52557_9_1
prompt =================================
prompt

CREATE OR REPLACE TYPE "SYS_PLSQL_52557_9_1"                                                                             as object (VALNUM NUMBER,
VALSTR VARCHAR2(4000),
VALDATE DATE);
/

prompt

prompt Creating type SYS_PLSQL_52557_29_1
prompt ==================================
prompt

CREATE OR REPLACE TYPE "SYS_PLSQL_52557_29_1"                                                                             as table of CP."SYS_PLSQL_52557_9_1";
/

prompt

prompt Creating type SYS_PLSQL_53513_DUMMY_1
prompt =====================================
prompt

CREATE OR REPLACE TYPE "SYS_PLSQL_53513_DUMMY_1"                                                                             as table of number;
/

prompt

prompt Creating type SYS_PLSQL_53513_9_1
prompt =================================
prompt

CREATE OR REPLACE TYPE "SYS_PLSQL_53513_9_1"                                                                             as object (VALNUM NUMBER,
VALSTR VARCHAR2(4000),
VALDATE DATE);
/

prompt

prompt Creating type SYS_PLSQL_53513_29_1
prompt ==================================
prompt

CREATE OR REPLACE TYPE "SYS_PLSQL_53513_29_1"                                                                             as table of CP."SYS_PLSQL_53513_9_1";
/

prompt

prompt Creating function CMPDATE
prompt =========================
prompt

CREATE OR REPLACE FUNCTION CMPDATE(a in DATE, b in DATE) return binary_integer deterministic
is
begin
   if a is null then
      if b is null then
         return 0;
      end if;
      return 1;
   end if;
   if b is null then
      return 1;
   end if;
   if a = b then
      return 0;
   end if;
   return 1;
end;
/
grant execute on CMPDATE to F_SMART_RO_ROLE;
grant execute on CMPDATE to PSA;


prompt

prompt Creating function CMPNUM
prompt ========================
prompt

CREATE OR REPLACE FUNCTION CMPNUM(a in number, b in number) return binary_integer deterministic
is
begin
   if a is null then
      if b is null then
         return 0;
      end if;
      return 1;
   end if;
   if b is null then
      return 1;
   end if;
   if a = b then
      return 0;
   end if;
   return 1;
end;
/
grant execute on CMPNUM to F_SMART_RO_ROLE;


prompt

prompt Creating function CMPSTR
prompt ========================
prompt

create or replace function CMPSTR(a in varchar2, b in varchar2) return binary_integer deterministic
is
begin
   if a is null then
      if b is null then
         return 0;
      end if;
      return 1;
   end if;
   if b is null then
      return 1;
   end if;
   if a = b then
      return 0;
   end if;
   return 1;
end;
/
grant execute on CMPSTR to F_SMART_RO_ROLE;


prompt

prompt Creating function ENABLED_ROLE
prompt ==============================
prompt

create or replace function ENABLED_ROLE(RoleName in varchar2) return integer is
begin
  if dbms_session.is_role_enabled(upper(RoleName))
  then
    return 1;
  else
    return 0;
  end if;
end ENABLED_ROLE;
/
grant execute on ENABLED_ROLE to F_SMART_RO_ROLE;


prompt

prompt Creating function GET_VAR_DATE
prompt ==============================
prompt

create or replace function get_var_date(p_var_name varchar2) return date is
  l_res date;
begin
  l_res := pkg_variable.get_var_date(p_var_name);
  return l_res;
end get_var_date;
/
grant execute on GET_VAR_DATE to F_SMART_RO_ROLE;


prompt

prompt Creating function GET_VAR_NUM
prompt =============================
prompt

create or replace function get_var_num(p_var_name varchar2) return number is
  l_res number;
begin
  l_res := pkg_variable.get_var_num(p_var_name);
  return l_res;
end get_var_num;
/
grant execute on GET_VAR_NUM to F_SMART_RO_ROLE;


prompt

prompt Creating function GET_VAR_STR
prompt =============================
prompt

create or replace function get_var_str(p_var_name varchar2) return varchar2 is
  l_res varchar2(4000);
begin
  l_res := pkg_variable.get_var_str(p_var_name);
  return l_res;
end get_var_str;
/
grant execute on GET_VAR_STR to F_SMART_RO_ROLE;


prompt

prompt Creating function LOCKTRANSLATE
prompt ===============================
prompt

CREATE OR REPLACE FUNCTION locktranslate(vrowid IN VARCHAR2)
  RETURN VARCHAR2 IS
  vresult VARCHAR2(2000);
BEGIN
  /*for c in (SELECT distinct 'Пользователь: ' || c.username || chr(10) ||
                            'Приложение: ' || c.program || chr(10) ||
                            'Объект: ' || o.oracle_username || '.' || b.NAME ||
                            chr(10) || 'Машина: ' || c.machine as name
              FROM v$session       a,
                   v$session       c,
                   V$LOCK          H,
                   V$LOCK          W,
                   v$locked_object o,
                   SYS.obj$        b
             WHERE a.row_wait_file# = DBMS_ROWID.rowid_relative_fno(vRowid)
               AND a.row_wait_block# = DBMS_ROWID.rowid_block_number(vRowid)
               AND a.row_wait_row# = DBMS_ROWID.rowid_row_number(vRowid)
               and H.LMODE <> 0
               AND H.LMODE <> 1
               AND W.REQUEST <> 0
               AND H.TYPE = W.TYPE
               and h.id1 = w.id1
               and h.id2 = w.id2
               and h.sid = c.sid
               and w.sid = a.sid
               AND o.session_id = c.SID
               AND b.type# = 2
               AND o.object_id = b.obj#) loop
    vresult := vresult || c.name || chr(10);
  end loop;*/
  RETURN(vresult);

EXCEPTION
  WHEN OTHERS THEN
    RETURN vresult;
END locktranslate;
/
grant execute on LOCKTRANSLATE to F_SMART_RO_ROLE;


prompt

prompt Creating function NCON
prompt ======================
prompt

CREATE OR REPLACE FUNCTION NCon( I in INTEGER, d in INTEGER) RETURN VARCHAR AS
begin
   return PkgDics.ncon(i, d);
end NCon;
/
grant execute on NCON to F_SMART_RO_ROLE;


prompt

prompt Creating function NDIC
prompt ======================
prompt

CREATE OR REPLACE FUNCTION NDic( I in INTEGER) RETURN VARCHAR AS
  Result varchar2 (100);
begin
   return PkgDics.ndic(i);
end NDic;
/
grant execute on NDIC to F_SMART_RO_ROLE;


prompt

prompt Creating function NE
prompt ====================
prompt

CREATE OR REPLACE FUNCTION Ne( I in INTEGER, d in INTEGER, isAbbr in integer default 0) RETURN VARCHAR AS
begin
   return PkgDics.ne(i, d, isAbbr);
end Ne;
/
grant execute on NE to F_SMART_RO_ROLE;


prompt

prompt Creating function SMARTFUNCTION
prompt ===============================
prompt

create or replace function smartfunction(p_id in number, p_param in number)
  return number is
  --p_ID - идентификатор набора, папки, контейнера и тд
  --p_Param - параметр функциональности
begin
  if p_param = 1 then
    --параметр отображения закладок в детализации для определенных пользователей
    if user in ('XXX') then
      return 1;
    else
      return 0;
    end if;
  elsif p_param = 2 then
    --ветка где хранятся все наборы которые возможно добавить в детализацию
    return 731;
  elsif p_param = 3 then
    --ветка для загрузки вспомогательных наборов в меню под "?"
    return 779;
  elsif p_param = 4 then
    --параметр для открытия редакции отчетов
    if user in ('XXX') then
      return 1;
    else
      return 0;
    end if;
  elsif p_param = 5 then
    --параметр для вершины дерева наборов для NLMKReport
    return 1361;
  elsif p_param = 6 then
    --параметр для админа "Служебные модули"
    if user in (
                'CP'
                ) then
      return 1;
    else
      return 0;
    end if;
  end if;
  return 0;
end;
/
grant execute on SMARTFUNCTION to F_SMART_RO_ROLE;


prompt

prompt Creating procedure LOGGER_CPP
prompt =============================
prompt

create or replace procedure LOGGER_CPP(p_mess varchar2) is
begin
  --syslog.logger.debug(p_mess);
  null;
end LOGGER_CPP;
/
grant execute on LOGGER_CPP to F_SMART_RO_ROLE;


prompt

prompt Creating function XML_EXTRACT_VALUE
prompt ===================================
prompt

create or replace function xml_extract_value(p_xml clob, p_tag varchar2)
  return varchar2 is
  l_Result varchar2(4000);
begin
  select extractValue(XMLTYPE(p_xml), p_tag) into l_Result from dual;
  return l_Result;
exception
  when others then
    --logger_cpp(SQLERRM);
    return SQLERRM;
end xml_extract_value;
/

prompt

prompt Creating procedure FLAG_DEC
prompt ===========================
prompt

create or replace procedure flag_dec(p_var_name varchar2) is
begin
  pkg_variable.dec(p_var_name);
end flag_dec;
/

prompt

prompt Creating procedure FLAG_INC
prompt ===========================
prompt

create or replace procedure flag_inc(p_var_name varchar2) is
begin
  pkg_variable.inc(p_var_name);
end flag_inc;
/

prompt

prompt Creating procedure GET_MAT_MTH
prompt ==============================
prompt

create or replace procedure GET_MAT_MTH is
 /* cursor c0 is
    select distinct (уид) id
      from EXP_МАТЕРИАЛЫ@mth.world t
     where \*rownum <= 100 and *\
     t.гр_мат_уид = 16;
  vc0 c0%rowtype;*/

begin
  /*for vc0 in c0 loop
    for vc1 in (select *
                  from EXP_МАТЕРИАЛЫ@mth.world t
                 where t.уид = vc0.id) loop
      insert into TMP_SPRAV_MTH
        (ID, name)
      values
        (vc1.уид, vc1.наименование);
    end loop;
  end loop;*/
  null;

end GET_MAT_MTH;
/

prompt

prompt Creating procedure RAISE_WARNING
prompt ================================
prompt

CREATE OR REPLACE PROCEDURE Raise_warning(vText in Varchar2) is
begin
  Raise_application_error(-20998, vText);
end Raise_warning;
/
grant execute on RAISE_WARNING to F_SMART_RO_ROLE;


prompt

prompt Creating procedure RAISE_WARNING_SILIEN
prompt =======================================
prompt

create or replace procedure Raise_warning_silien(vText in Varchar2) is
begin
  Raise_application_error(-20999, vText); -- ошибки не логируются в LPPAudite
end Raise_warning_silien;
/
grant execute on RAISE_WARNING_SILIEN to F_SMART_RO_ROLE;


prompt

prompt Creating procedure SENDMAILFROMUSER
prompt ===================================
prompt

create or replace procedure SendMailFromUser(SubjTitle VARCHAR2,
                                             Message   VARCHAR2) IS
  Sender         VARCHAR2(50);
  SenderTitle    VARCHAR2(50);
  FromTitle      VARCHAR2(50);
  Recipient      VARCHAR2(50);
  RecipientTitle VARCHAR2(50);
  ToTitle        VARCHAR2(50);
  Mailhost       VARCHAR2(30) := 'localhost';
  Mail_conn      utl_smtp.connection;
BEGIN
  select admin_email into Sender from smart_audit_config where rownum = 1;
  SenderTitle    := Sender;
  FromTitle      := Sender;
  Recipient      := Sender;
  RecipientTitle := Sender;
  ToTitle        := Sender;

  mail_conn := utl_smtp.open_connection(mailhost, 25);
  utl_smtp.helo(mail_conn, Mailhost);
  utl_smtp.mail(mail_conn, Sender);
  utl_smtp.rcpt(mail_conn, Recipient);

  utl_smtp.open_data(mail_conn);

  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw(CONVERT('From: ' || FromTitle || '<' ||
                                                      SenderTitle || '>',
                                                      'CL8KOI8R',
                                                      'CL8ISO8859P5') ||
                                              utl_tcp.CRLF));
  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw(CONVERT('To: ' || ToTitle || '<' ||
                                                      RecipientTitle || '>',
                                                      'CL8KOI8R',
                                                      'CL8ISO8859P5') ||
                                              utl_tcp.CRLF));
  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw(CONVERT('Subject: BFM.NLMK ' ||
                                                      SubjTitle,
                                                      'CL8KOI8R',
                                                      'CL8ISO8859P5') ||
                                              utl_tcp.CRLF));
  /*
    utl_smtp.write_raw_data(mail_conn,
                            utl_raw.cast_to_raw('Date:' ||
                                                to_char(SYSDATE,
                                                        ' Dy, DD Mon IYYY HH24:MI:SS',
                                                        'NLS_DATE_LANGUAGE=English') ||
                                                ' +0300 (MSK)' ||
                                                utl_tcp.CRLF));
  */
  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw('MIME-Version: 1.0' ||
                                              utl_tcp.CRLF));
  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw('Content-Language: ru' ||
                                              utl_tcp.CRLF));
  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw('Content-Type:  text/plain;' ||
                                              utl_tcp.CRLF ||
                                              ' type=text/plain; charset=koi8-r' ||
                                              utl_tcp.CRLF));
  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw('Content-Transfer-Encoding: 8bit' ||
                                              utl_tcp.CRLF));
  utl_smtp.write_raw_data(mail_conn, utl_raw.cast_to_raw(utl_tcp.CRLF));
  utl_smtp.write_raw_data(mail_conn,
                          utl_raw.cast_to_raw(CONVERT(Message,
                                                      'CL8KOI8R',
                                                      'CL8ISO8859P5') ||
                                              utl_tcp.CRLF ||
                                              CONVERT('Системное время: ',
                                                      'CL8KOI8R',
                                                      'CL8ISO8859P5') ||
                                              to_char(sysdate,
                                                      'DD.MM.YYYY HH24:MI:SS ') ||
                                              CONVERT('Владелец сессии: ',
                                                      'CL8KOI8R',
                                                      'CL8ISO8859P5') || USER ||
                                              CONVERT(' APPCode:',
                                                      'CL8KOI8R',
                                                      'CL8ISO8859P5') ||
                                              Pkgaudit.v_App_Code ||
                                              utl_tcp.CRLF));
  utl_smtp.close_data(mail_conn);

  utl_smtp.quit(mail_conn);

exception
  when others then
    --logger_cpp(SQLERRM);
    raise;
end SendMailFromUser;
/
grant execute on SENDMAILFROMUSER to F_SMART_RO_ROLE;


prompt

prompt Creating procedure SET_VAR_DATE
prompt ===============================
prompt

create or replace procedure set_var_date(p_var_name varchar2, p_value date) is
begin
  pkg_variable.set_var_date(p_var_name, p_value);
end set_var_date;
/

prompt

prompt Creating procedure SET_VAR_NUM
prompt ==============================
prompt

create or replace procedure set_var_num(p_var_name varchar2, p_value number) is
begin
  pkg_variable.set_var_num(p_var_name, p_value);
end set_var_num;
/


prompt

prompt Creating procedure SET_VAR_STR
prompt ==============================
prompt

create or replace procedure set_var_str(p_var_name varchar2, p_value varchar2) is
begin
  pkg_variable.set_var_str(p_var_name, p_value);
end set_var_str;
/

prompt

prompt Creating package body PKGAUDIT
prompt ==============================
prompt

create or replace package body pkgaudit is
  function get_app_code return integer is
  begin
    return v_app_code;
  end;
  -----------------------------------------------------------------------------------
  function sendbugreport(v_subj in varchar2, v_text in varchar2)
    return integer is
    l_id_picture integer;
    l_messaga    varchar(30000);
  begin
    begin
      select smart_audit_exceptions_log_seq.nextval
        into l_id_picture
        from dual;
      l_messaga := 'Exception:' || l_id_picture || ' ' || v_subj ||
                   ' Body: | | ' || v_text;
      sendmailfromuser(v_subj, v_text);
      --logger_cpp(l_messaga);
    exception
      when others then
        sendmailfromuser('Ошибка логгера:', sqlerrm);
        raise;
    end;
    return l_id_picture; -- вернем ID для записи картинки.
  end;
  -----------------------------------------------------------------------------------
  procedure checkgrant(v_app_code       in integer,
                       v_filter         in varchar2,
                       v_con_type_check in integer) is
    v_smart_grant_row smart_grant%rowtype;
    v_count_start     integer;
  begin
    begin
      select *
        into v_smart_grant_row
        from smart_grant t
       where t.con_type_check = v_con_type_check
         and t.filter = nvl(v_filter, '-')
         and t.appcode = v_app_code;
      select v_smart_grant_row.count_start
        into v_count_start
        from smart_grant t
       where t.con_type_check = v_con_type_check
         and t.filter = nvl(v_filter, '-')
         and t.appcode = v_app_code;
      update smart_grant t
         set t.count_start = t.count_start + 1
       where t.con_type_check = v_con_type_check
         and t.filter = nvl(v_filter, '-')
         and t.appcode = v_app_code;
      commit;
    exception
      when no_data_found then
        insert into smart_grant
          (appcode, filter, enabled, con_type_check)
        values
          (v_app_code, nvl(v_filter, '-'), 1, v_con_type_check);
        v_smart_grant_row.enabled := 1;
        commit;
      when others then
        commit;
        sendmailfromuser('CheckGrant', sqlerrm);
    end;
    if v_smart_grant_row.enabled = 0 then
      v_error_message := 'Запуск приложения для Вас заперещен - обратитесь к администратору базы данных';
      v_returncode    := ppaauditforbidden;
    end if;
  end;
  -----------------------------------------------------------------------------------
  function startapp(app_code     in integer,
                    mac          in varchar2,
                    hostname     in varchar2,
                    ip           in varchar2,
                    osversion    in varchar2,
                    currentbuild in varchar2) return integer is
    l_base_role varchar2(30);
    l_note      varchar2(1000);
  begin
    sys.dbms_session.set_nls('NLS_NUMERIC_CHARACTERS','",."'); --[+]pimenov_pa 30.09.2011 Для стабилизации расчета хеша.
    v_returncode := null;
    v_app_code   := app_code;
    select lastbuild, exename, nvl(tree_number, 0), note
      into v_lastbuild, v_exename, v_tree_number, l_note
      from smart_audit_app a
     where a.appcode = app_code;
    select smart_audit_applog_seq.nextval
      into v_current_audit_id
      from dual;
    insert into smart_audit_applog
      (id, appcode, mac, ip, hostname, osversion, curbuild)
    values
      (v_current_audit_id,
       app_code,
       mac,
       ip,
       hostname,
       osversion,
       currentbuild);
    commit;
  
    if v_lastbuild > currentbuild then
      v_returncode := ppaauditoldbuild;
    end if;
    checkgrant(app_code, ip, 1);
    checkgrant(app_code, user, 2);
    checkgrant(app_code, hostname, 3);
    select trim(upper(base_role))
      into l_base_role
      from smart_audit_app
     where appcode = app_code;
    if l_base_role is not null then
      if not dbms_session.is_role_enabled(l_base_role) then
        v_error_message := 'Приложение: ' || l_note || ' ( ' || v_exename || ')' ||
                           chr(10) ||
                           'У Вас нет прав для запуска данного приложения.';
        v_note_message  := '<pimenov_pa@nlmk.ru>, тел. 54633';
        return ppaauditforbidden;
      end if;
    end if;
    return v_returncode;
  end;
  -----------------------------------------------------------------------------------
  function stopapp(idummy in integer) return integer is
  begin
    update smart_audit_applog
       set shutdate = sysdate, returncode = v_returncode
     where id = v_current_audit_id;
    commit;
    return(0);
  end;
  function gettreenumber(idummy in integer) return integer is
  begin
    return v_tree_number;
  end;
begin
  v_error_message := 'Изменилось окружение клиента.';
  v_note_message  := 'Необходимо связаться с администратором БД для уточнения полномочий.';
end pkgaudit;
/
grant execute on PKGAUDIT to F_SMART_RO_ROLE;


prompt

prompt Creating package body PKGAUDIT_EMAIL
prompt ====================================
prompt

create or replace package body pkgaudit_email is
  ---------------------------------------------------------------------------------------------------------------
  procedure sendmail(p_msg       varchar2,
                     p_subject   varchar2,
                     p_recipient varchar2) is
    /*
    Сообщение отправляется в кодировке koi8-r
    Поэтому производится перекодировка
    из базовой кодировки "CL8ISO8859P5 в "CL8KOI8R"
    */
    mail_conn           utl_smtp.connection;
    l_server            varchar2(255);
    l_fulsender         varchar2(255);
    l_recipient         varchar2(255);
    l_mail_host         varchar2(20) := 'post.nlmk';
    l_recipient_postfix varchar2(20) := '@nlmk.ru';
  begin
    select * into l_server from global_name where rownum = 1;
    l_fulsender := 'oracle@' || l_server;
    if instr(p_recipient, l_recipient_postfix) = 0 then
      l_recipient := p_recipient || l_recipient_postfix;
    else
      l_recipient := p_recipient;
    end if;
    mail_conn := utl_smtp.open_connection(l_mail_host, 25);
    utl_smtp.helo(mail_conn, l_mail_host);
    utl_smtp.mail(mail_conn, l_fulsender);
    utl_smtp.rcpt(mail_conn, l_recipient);
    utl_smtp.open_data(mail_conn);
    utl_smtp.write_raw_data(mail_conn,
                            utl_raw.cast_to_raw(convert('From: ' ||
                                                        l_fulsender,
                                                        'CL8KOI8R',
                                                        'CL8ISO8859P5') ||
                                                utl_tcp.crlf));
    utl_smtp.write_raw_data(mail_conn,
                            utl_raw.cast_to_raw(convert('To: ' || '<' ||
                                                        l_recipient || '>',
                                                        'CL8KOI8R',
                                                        'CL8ISO8859P5') ||
                                                utl_tcp.crlf));
    utl_smtp.write_raw_data(mail_conn,
                            utl_raw.cast_to_raw(convert('Subject: ' ||
                                                        p_subject,
                                                        'CL8KOI8R',
                                                        'CL8ISO8859P5') ||
                                                utl_tcp.crlf));
    utl_smtp.write_raw_data(mail_conn,
                            utl_raw.cast_to_raw(convert('Content-Language: ru',
                                                        'CL8KOI8R',
                                                        'CL8ISO8859P5') ||
                                                utl_tcp.crlf));
    utl_smtp.write_raw_data(mail_conn,
                            utl_raw.cast_to_raw(convert('Content-Type: text/plain; charset=koi8-r',
                                                        'CL8KOI8R',
                                                        'CL8ISO8859P5') ||
                                                utl_tcp.crlf));
    utl_smtp.write_raw_data(mail_conn,
                            utl_raw.cast_to_raw(convert('Content-Transfer-Encoding: 8bit',
                                                        'CL8KOI8R',
                                                        'CL8ISO8859P5') ||
                                                utl_tcp.crlf));
    if p_msg is not null then
      utl_smtp.write_raw_data(mail_conn,
                              utl_raw.cast_to_raw(utl_tcp.crlf ||
                                                  convert(p_msg,
                                                          'CL8KOI8R',
                                                          'CL8ISO8859P5') ||
                                                  utl_tcp.crlf));
    end if;
    utl_smtp.close_data(mail_conn);
    utl_smtp.quit(mail_conn);
  exception
    when others then
      --logger_cpp('send_mail sqlerrm: ' || sqlerrm);
      raise;
  end;
  ---------------------------------------------------------------------------------------------------------------
  --список админов
  function addadmin(p_recipients varchar2, p_symbol in out varchar2)
    return varchar2 is
    l_res    varchar2(255);
    l_server varchar2(100);
  begin
    l_res := upper(p_recipients);
    if instr(l_res, 'ADMIN') > 0
    --grishkov_mn 16.06.2010 по большой просьбе Санька отключил рассылку всем,
    --если в адресе есть Паша
    -- or instr(l_res, 'PIMENOV_PA') > 0
     then
      if p_symbol is null then
        p_symbol := ',';
      end if;
      l_res := replace(l_res, 'ADMIN');
      select * into l_server from global_name where rownum = 1;
      if l_server = 'CCM4.NLMK' then
        l_res := l_res || p_symbol || 'PIMENOV_PA' || p_symbol ||
                 'POPOV_AV5' || p_symbol || 'RYBLOV_AV' || p_symbol ||
                 'LEBEDEV_NV';
      elsif l_server = 'CCM2.NLMK' then
        l_res := l_res || p_symbol || 'PIMENOV_PA' || p_symbol ||
                 'POPOV_AV5' || p_symbol || 'RYUMKINA_ED';
      elsif l_server = 'PRDWSPI.NLMK' then
        l_res := l_res || p_symbol || 'PIMENOV_PA' || p_symbol ||
                 'GROSHEV_KA';
      elsif l_server = 'NMES.NLMK' then
        l_res := l_res || p_symbol || 'PIMENOV_PA' || p_symbol ||
                 'GROSHEV_KA';
      elsif l_server like 'KKC%.NLMK' then
        l_res := l_res || p_symbol || 'egorov_ag';
      elsif l_server like 'BFM.NLMK' then
        l_res := l_res || p_symbol || 'chernyh_mg';
      elsif l_server like 'SCRAP.NLMK' then
        l_res := l_res || p_symbol || 'chernyh_mg';
      else
        l_res := l_res || p_symbol || 'PIMENOV_PA';
      end if;
    end if;
    l_res := ltrim(l_res, ',');
    return l_res;
  end;
  ---------------------------------------------------------------------------------------------------------------
  procedure multisender(p_msg        varchar2,
                        p_subject    varchar2,
                        p_recipients varchar2) is
    l_symbol     varchar2(1) := null;
    l_recipients varchar2(255);
  begin
    if instr(p_recipients, ',') > 0 then
      l_symbol := ',';
    elsif instr(p_recipients, ';') > 0 then
      l_symbol := ';';
    end if;
    l_recipients := addadmin(p_recipients, l_symbol);
    for q in (select valstr
                from table(pkgcommatext.getuniquetable(l_recipients,
                                                       l_symbol,
                                                       2))) loop
      sendmail(p_msg, p_subject, q.valstr);
    end loop;
  end;
  ----------------------------------------------------------------------------------------------------

end pkgaudit_email;
/
grant execute on PKGAUDIT_EMAIL to F_SMART_RO_ROLE;


prompt

prompt Creating package body PKGCOMMATEXT
prompt ==================================
prompt

create or replace package body PkgCommaText is
  ---------------------------------------------------------------------------
  function GetID(v_comma_text in varchar2, v_sep in varchar2 := ',')
    return t_id_array is
    v_ID           t_id_array := t_id_array();
    v_len          int;
    v_current_int  varchar2(30);
    v_current_char varchar2(1);
  begin
    v_len := length(v_comma_text);
    for i in 1 .. v_len loop
      v_current_char := substr(v_comma_text, i, 1);
      v_current_int  := v_current_int || v_current_char;
      if v_current_char = v_sep or i = v_len then
        v_ID.extend(1);
        v_ID(v_ID.count) := to_number(v_current_int);
        v_current_int := '';
      end if;
    end loop;
    return v_ID;
  end;
  ---------------------------------------------------------------------------
  --grishkov_mn 14.05.2010 (Парсер разных типов)
  --p_type = 1 - number,
        -- = 2 - varcha2
        -- = 3 - date
  function GetTable(p_commatext  varchar2,
                    p_sep_symbol varchar2,
                    p_type       number,
                    p_date_mask  varchar2) return TTable PIPELINED is
    l_row TRow;
    l_len          int;
    l_current_val  varchar2(30);
    l_current_char varchar2(1);
  begin
    l_len := length(p_commatext);
    for i in 1 .. l_len + 1 loop
      l_current_char := substr(p_commatext, i, 1);
      if l_current_char = p_sep_symbol
         or i > l_len
      then
        l_current_val := trim (l_current_val);
        case p_type when 1 /*Число*/
                    then l_row.ValNum := to_number(l_current_val);
                    when 2 /*Строка*/
                    then l_row.ValStr := l_current_val;
                    when 3 /*Дата*/
                    then l_row.ValDate := to_date(l_current_val, p_date_mask);
        end case;
        PIPE ROW (l_row);
        l_current_val := '';
      else
        l_current_val  := l_current_val || l_current_char;
      end if;
    end loop;
    return;
  end;
  ---------------------------------------------------------------------------
  --grishkov_mn 14.05.2010 (Парсер разных типов с соблюдением уникальности)
  --p_type = 1 - number,
        -- = 2 - varcha2
        -- = 3 - date
  function GetUniqueTable(p_commatext  varchar2,
                          p_sep_symbol varchar2,
                          p_type       number,
                          p_date_mask  varchar2 := null) return TTable PIPELINED is
    l_row TRow;
  begin
    for q in (select distinct ValNum,
                              ValStr,
                              ValDate
                from table(GetTable(p_commatext,
                                    p_sep_symbol,
                                    p_type,
                                    p_date_mask)))
    loop
      l_row.ValNum  := q.ValNum;
      l_row.ValStr  := q.ValStr;
      l_row.ValDate := q.ValDate;
      PIPE ROW (l_row);
    end loop;
    return;
  end;
end PkgCommaText;
/

prompt

prompt Creating package body PKG_CONST
prompt ===============================
prompt

create or replace package body PKG_CONST is

  --Получить значение число
  function get_const_num(p_const_name varchar2) return number is
    l_res number;
  begin
    select c.const_val_num
      into l_res
      from const c
     where c.const_name = p_const_name;
    return l_res;
  exception when NO_DATA_FOUND
            then raise_warning('Константа ' || p_const_name || ' не найдена');
  end;
  --Получить значение строка
  function get_const_str(p_const_name varchar2) return varchar2 is
    l_res varchar2(4000);
  begin
    select c.const_val_str
      into l_res
      from const c
     where c.const_name = p_const_name;
    return l_res;
  exception when NO_DATA_FOUND
            then raise_warning('Константа ' || p_const_name || ' не найдена');
  end;
  --Получить значение дата
  function get_const_date(p_const_name varchar2) return date is
  l_res date;
  begin
    select c.const_val_date
      into l_res
      from const c
     where c.const_name = p_const_name;
    return l_res;
  exception when NO_DATA_FOUND
            then raise_warning('Константа ' || p_const_name || ' не найдена');
  end;

end PKG_CONST;
/

prompt

prompt Creating package body PKGDICS
prompt =============================
prompt

CREATE OR REPLACE PACKAGE BODY PkgDics as
  -----------------------------------------------------------------------------
  v_Shift integer := 100000000000;
  type t_Array is table of varchar2(300) index by varchar2(38);
  v_Array          t_Array;
  v_ArrayENUM      t_Array;
  v_ArrayENUM_Abbr t_Array;
  -----------------------------------------------------------------------------
  function ne(v_ID   in integer,
              v_DIC  in integer,
              isAbbr in integer default 0) return varchar2 is
    v_Name  varchar2(600);
    v_Index varchar2(238);
    v_Abbr  varchar2(600);
  begin
    if v_ID is null or v_DIC is null then
      return null;
    end if;
    v_Index := v_ID || '~' || v_DIC;
    if isAbbr = 0 then
      return v_ArrayENUM(v_Index);
    else
      return v_ArrayENUM_Abbr(v_Index);
    end if;
  exception
    when no_data_found then
   /*   select NAME, abbr
        into v_Name, v_Abbr
        from v_dics
       where DIC = v_DIC
         and ID = v_ID;*/
      v_ArrayENUM(v_Index) := v_Name;
      v_ArrayENUM_Abbr(v_Index) := v_Abbr;
      if isAbbr = 0 then
        return v_Name;
      else
        return v_Abbr;
      end if;
    when others then
      return '<error-ENUM=' || v_DIC || ' v_Index=' || v_Index || '>' || SQLERRM;
  end;
  -----------------------------------------------------------------------------
  function ndic(v_ID in integer) return varchar2 is
    v_Name varchar2(300);
  begin
    if v_ID is null then
      return null;
    end if;
    return v_Array(v_ID);
  exception
    when no_data_found then
      select NAME into v_Name from DICS where ID = v_ID;
      v_Array(v_ID) := v_Name;
      return v_Name;
  end;
  -----------------------------------------------------------------------------
  function ncon(v_ID in integer, v_DIC in integer) return varchar2 is
    v_Name  varchar2(300);
    v_Index varchar2(38);
  begin
    if v_ID is null or v_DIC is null then
      return null;
    end if;
    if v_ID < 0 or v_ID > (v_Shift - 1) or v_DIC < 0 or v_DIC > 999 then
      select NAME
        into v_Name
        from CONS
       where DIC = v_DIC
         and ID = v_ID;
      return v_Name;
    end if;
    v_Index := v_DIC * v_Shift + v_ID;
    return v_Array(v_Index);
  exception
    when no_data_found then
      if v_Index is not null then
        select NAME
          into v_Name
          from CONS
         where DIC = v_DIC
           and ID = v_ID;
        v_Array(v_Index) := v_Name;
      end if;
      return v_Name;
  end;
  -----------------------------------------------------------------------------
  -- Добавить слово в словарь с заданным номером, если нет такого слова
  -- если есть и если нет - вернуть ID слова
  function Add(DICIN in NUMBER, NAMEIN in VARCHAR2) return integer is
    v_id_found integer;
    v_DIC_ID   dics.dic_id%type;
  begin
    IF Trim(NAMEIN) IS NULL THEN
      RETURN(NULL);
    END IF;
    Select id, DIC_ID
      into v_id_found, v_DIC_ID
      from Dics
     where NAME = Trim(NAMEIN)
       AND DIC = DICIN;
    IF v_DIC_ID is not null THEN
      return v_DIC_ID;
    ELSE
      return v_id_found;
    END IF;
  exception
    when no_data_found then
     -- raise_warning('Не поддерживается на этом сервере - ppa@nlmk.ru');
           Select DICS_SEQ.NextVal into v_id_found from dual;
           insert into Dics (ID, DIC, NAME) VALUES (v_id_found, DICIN, Trim(NAMEIN));
      return(v_id_found);
  end;
  -----------------------------------------------------------------------------
end PkgDics;
/


prompt

prompt Creating package body PKGFILESTORAGE
prompt ====================================
prompt

create or replace package body PKGFILESTORAGE as

  procedure CheckGrant is
  BEGIN
   null;
  END;
  procedure DeleteFile(v_Name in varchar2) is
  BEGIN
    delete from fileheader where UPPER(filename) = UPPER(v_Name);
  END;
begin
  v_mutex := false;
end PKGFILESTORAGE;
/
grant execute on PKGFILESTORAGE to F_SMART_RO_ROLE;


prompt

prompt Creating package body PKGFILTERSTREE
prompt ====================================
prompt

create or replace package body PKGFILTERSTREE is
  ---------------------------------------------------------------------------------------
  function GetRegKey(p_filter_tree_id in number) return varchar2 is
    Result varchar2(4000);
  begin
    for c in (select *
                from filters_tree /*where (user_name=upper(user) and pmname=upper(pm_name))*/
               start with id = p_filter_tree_id
              connect by prior filter_id = id
               order by id) loop
      --     if c.parent_id is not null then
      Result := Result || c.name || '\';
      --     end if;
    end loop;
    Result := SubStr(Result, 1, Length(Result) - 1);
    return(Result);
  end;
  ---------------------------------------------------------------------------------------
  procedure ClearUserFilters(p_PMName in varchar2) is
  begin
    DELETE FROM FILTERS_TREE
     WHERE USER_NAME = UPPER(USER)
       AND PMNAME = p_PMName;
  exception
    when others then
      Raise_Warning('Произошла ошибка при удалении фильтров пользователя - ' || USER);
  end;
  ---------------------------------------------------------------------------------------
end PKGFILTERSTREE;
/
grant execute on PKGFILTERSTREE to F_SMART_RO_ROLE;


prompt

prompt Creating package body PKGSMARTFIELDS
prompt ====================================
prompt

create or replace package body PkgSmartFields is
  --для аналитики
  g_VarType         number;
  g_VarBeginValue   varchar2(30);
  g_VarEndValue     varchar2(30);
  g_VarOneFieldName varchar2(30);
  g_VarTwoFieldName varchar2(30);

  function VarType return number is
  begin
    return g_VarType; /*если 1 - дата, 0 - число*/
  end;

  function VarBeginValue return varchar2 is
  begin
    return g_VarBeginValue;
  end;

  function VarEndValue return varchar2 is
  begin
    return g_VarEndValue;
  end;

  function VarOneFieldName return varchar2 is
  begin
    return g_VarOneFieldName; /*наименование поля*/
  end;

  function VarTwoFieldName return varchar2 is
  begin
    return g_VarTwoFieldName; /*наименование поля*/
  end;

  procedure SetAnalyticValue(p_Type         in number,
                             p_BeginValue   in varchar2,
                             p_EndValue     in varchar2,
                             p_OneFieldName in varchar2,
                             p_TwoFieldName in varchar2) is
  begin
    g_VarType         := p_Type;
    g_VarBeginValue   := p_BeginValue;
    g_VarEndValue     := p_EndValue;
    g_VarOneFieldName := p_OneFieldName;
    g_VarTwoFieldName := p_TwoFieldName;
  end;
  -------------------------------------------------------------------
  function AdminUsers return number is
  begin
    return enabled_role('F_SMART_RW_ROLE');
  end;
  --------------------------------------------------------------------
  function GetRegKey(p_filter_tree_id in number) return varchar2 is
    Result varchar2(2000);
  begin
    for c in (select *
                from filters_tree
               start with id = p_filter_tree_id
              connect by prior filter_id = id
               order by id) loop
      Result := Result || c.name || '\';
    end loop;
    Result := SubStr(Result, 1, Length(Result) - 1);
    return(Result);
  end;
  --------------------------------------------------------------------------------
  procedure AuditOpenSDS(p_ppa_audit_applog_id in number,
                         p_id                  in number,
                         p_is_new              in number) is
    --v_is_audit number;
    pragma autonomous_transaction;
  begin
    /*[-] popov_av5 28.02.2012 логируем всегда
    if p_is_new = 1 then
      --композитный набор
      select nvl(max(is_audit), 0)
        into v_is_audit
        from smart_class
       where smart_dset_id = p_id;
    else
      select is_audit into v_is_audit from smart_dset where id = p_id;
    end if;*/
    --
    /*[-] popov_av5 24.03.2012 if v_is_audit = 1 and AdminUsers = 0 then*/
    insert into smart_dset_audit
      (ppa_audit_applog_id, smart_dset_id, date_event)
    values
      (p_ppa_audit_applog_id, p_id, sysdate);
    commit;
    /*end if;*/
  exception
    when others then
      rollback;
      raise;
  end;
  -----------------------------------------------------------------------
  function DetailAuditOpenSDS(p_ppa_audit_applog_id in number,
                              p_id                  in number,
                              p_EXEC_SQL            in clob,
                              p_ACTION_NAME         in varchar2,
                              p_upd_id              in integer,
                              p_is_new              in number) return integer is
    v_is_audit number;
    v_new_id   integer;
    pragma autonomous_transaction;
  begin
    if p_is_new = 1 then
      --композитный набор
      select is_audit into v_is_audit from smart_class where id = p_id;
    else
      select is_audit into v_is_audit from smart_dset where id = p_id;
    end if;
    --
    if v_is_audit = 1 and AdminUsers = 0 then
      if p_upd_id = -1 then
        insert into SMART_DSET_AUDIT_DETAIL
          (ppa_audit_applog_id,
           smart_dset_id,
           EXEC_SQL,
           ACTION_NAME,
           smart_class_id)
        values
          (p_ppa_audit_applog_id,
           decode(p_is_new, 1, null, p_id),
           p_EXEC_SQL,
           p_ACTION_NAME,
           decode(p_is_new, 1, p_id, null))
        returning id into v_new_id;
        commit;
      elsif p_upd_id <> -1 then
        update SMART_DSET_AUDIT_DETAIL
           set date_event_end = sysdate
         where id = p_upd_id;
        commit;
        v_new_id := 0;
      end if;
    end if;
    return v_new_id;
  exception
    when others then
      rollback;
      raise;
  end;
  -----------------------------------------------------------------------
  -- процедура для сортировки полей в редакторе групп по имени
  procedure DicFilterNameSort(v_dic_tree_id in int) is
    v_max_sort_num int;
  begin
    select max(sort_num) into v_max_sort_num from dics_tree;
    for c in (select id
                from dics_tree
               where dic_tree_id = v_dic_tree_id
               order by name_folder) loop
      v_max_sort_num := v_max_sort_num + 1;
      update dics_tree set sort_num = v_max_sort_num where id = c.id;
    end loop;
  end;
  --
  procedure CopyReportField(p_FK_ID in number, p_NewFK_ID in number) is
    v_smart_class_row  smart_class%rowtype;
    v_smart_script_row smart_script%rowtype;
  begin
    for ff in (select *
                 from smart_class
                where fk_id = p_FK_ID
                order by sort_num) loop
      select * into v_smart_class_row from smart_class where id = ff.id;
      select SMART_CLASS_SEQ.nextval into v_smart_class_row.id from dual;
      select nvl(max(sort_num), 0) + 1
        into v_smart_class_row.sort_num
        from smart_class
       where smart_dset_id = v_smart_class_row.smart_dset_id;
      v_smart_class_row.fk_id  := p_NewFK_ID;
      v_smart_class_row.tag_id := v_smart_class_row.id;
      insert into smart_class values v_smart_class_row;
      --
      select *
        into v_smart_script_row
        from smart_script
       where smart_class_id = ff.id;
      select SMART_SCRIPT_SEQ.nextval into v_smart_script_row.id from dual;
      v_smart_script_row.smart_class_id := v_smart_class_row.id;
      insert into smart_script values v_smart_script_row;
      --
      CopyReportField(ff.id, v_smart_class_row.id);
    end loop;
  end;
  --
  function CopyReport(p_ClassID in number,
                      p_FK_ID   in number,
                      p_Name    in varchar2) return number is
    v_smart_class_row  smart_class%rowtype;
    v_smart_script_row smart_script%rowtype;
  begin
    select * into v_smart_class_row from smart_class where id = p_ClassID;
    select SMART_CLASS_SEQ.nextval into v_smart_class_row.id from dual;
    select nvl(max(sort_num), 0) + 1
      into v_smart_class_row.sort_num
      from smart_class
     where smart_dset_id = v_smart_class_row.smart_dset_id;
    v_smart_class_row.fk_id  := p_FK_ID;
    v_smart_class_row.name   := p_Name;
    v_smart_class_row.tag_id := v_smart_class_row.id;
    insert into smart_class values v_smart_class_row;
    --
    select *
      into v_smart_script_row
      from smart_script
     where smart_class_id = p_ClassID;
    select SMART_SCRIPT_SEQ.nextval into v_smart_script_row.id from dual;
    v_smart_script_row.smart_class_id := v_smart_class_row.id;
    insert into smart_script values v_smart_script_row;
    --
    CopyReportField(p_ClassID, v_smart_class_row.id);
    --
    return v_smart_class_row.id;
  end;
  --
  function GetIntervalScript(p_class_id in number, p_user in varchar2)
    return clob is
    v_script clob;
  begin
    select script
      into v_script
      from smart_script
     where date_history is null
       and smart_class_id =
           (select t.id
              from smart_class t, smart_script s
             where t.id = s.smart_class_id
               and s.date_history is null
               and t.ftype = 77 /*sctGroupingInterval*/
               and extractvalue(XMLType(s.script),
                                '/TFastGroupingInterval/User') = p_user
               and t.fk_id = p_class_id);
    return v_script;
  exception
    when no_data_found then
      return null;
  end;
  --
  function GetIntervalLabel(p_begin_value in varchar2,
                            p_end_value   in varchar2,
                            p_lookup_type in number,
                            p_lookup_num  in number) return varchar2 is
  begin
    --p_lookup_type
    --0: estNone
    --1: estDic
    --2: estCon
    --3: estEnum
  
    if p_begin_value is null then
      return null;
    end if;
    --
    if p_lookup_type = 0 then
      if p_begin_value = '0' then
        return '< ' || p_end_value;
      end if;
      if p_end_value is null then
        return '>= ' || p_begin_value;
      else
        return p_begin_value || ' - ' || p_end_value;
      end if;
    else
      if p_lookup_type = 1 then
        return ndic(p_begin_value);
      elsif p_lookup_type = 2 then
        return ncon(p_begin_value, p_lookup_num);
      elsif p_lookup_type = 3 then
        return ne(p_begin_value, p_lookup_num);
      else
        return p_begin_value;
      end if;
    end if;
  end;
  --                           
  function GetIntervalField(p_begin_value in varchar2,
                            p_end_value   in varchar2,
                            p_lookup_type in number,
                            p_data_type   in number,
                            p_field_name  in varchar2) return varchar2 is
    v_begin_value varchar2(100);
    v_end_value   varchar2(100);
  begin
    --p_lookup_type
    --0: estNone
    --1: estDic
    --2: estCon
    --3: estEnum
  
    --p_data_type
    --1: mtfString
    --2: mtfFloat
    --3: mtfDate
    --4: mtfInteger
    --6: mtfCurrency
  
    if p_begin_value is null then
      return p_field_name || ' is null';
    end if;
    --
    if p_lookup_type = 0 then
      if p_data_type = 1 then
        --если строка
        v_begin_value := '''' || p_begin_value || '''';
        v_end_value   := '''' || p_end_value || '''';
      elsif p_data_type in (2, 4, 6) then
        --если дробное число
        v_begin_value := replace(p_begin_value, ',', '.');
        v_end_value   := replace(p_end_value, ',', '.');
      elsif p_data_type = 3 then
        --если дата
        v_begin_value := 'to_date(''' || p_begin_value ||
                         ''',''DD.MM.YYYY HH24:MI:SS'')';
        v_end_value   := 'to_date(''' || p_end_value ||
                         ''',''DD.MM.YYYY HH24:MI:SS'')';
      end if;
      --
      if p_begin_value = '0' then
        return p_field_name || ' < ' || v_end_value;
      end if;
      if p_end_value is null then
        return v_begin_value || ' <= ' || p_field_name;
      else
        return v_begin_value || ' <= ' || p_field_name || ' and ' || p_field_name || ' < ' || v_end_value;
      end if;
    else
      return p_field_name || ' = ' || p_begin_value;
    end if;
  end;
  --                          
  function CreateClass(p_Name     in varchar2,
                       p_ListID   in number,
                       p_ParentID in number,
                       p_Type     in number,
                       p_SortNum  in number, /*:=null*/
                       p_ObjID    in number /*:=null*/) return integer is
    v_SortNum number;
    v_NewID   number;
  begin
    v_SortNum := p_SortNum;
    if v_SortNum is null then
      select nvl(max(sort_num), 0) + 1
        into v_SortNum
        from smart_class
       where smart_dset_id = p_ListID;
    end if;
    insert into smart_class
      (fk_id, smart_dset_id, sort_num, ftype, name, obj_id)
    values
      (p_ParentID, p_ListID, v_SortNum, p_Type, p_Name, p_ObjID)
    returning id into v_NewID;
    --
    return v_NewID;
  end;
  --
  procedure DeleteClass(p_ID in number) is
  begin
    delete smart_class where id = p_ID;
  end;
  --
  procedure SetScript(p_ClassID in number,
                      p_Script  in clob,
                      p_Date    in date /*:=null*/) is
  begin
    insert into smart_script
      (smart_class_id, script, date_history)
    values
      (p_ClassID, p_Script, p_Date);
  end;
  --
  procedure UpdScript(p_ClassID in number,
                      p_Script  in clob,
                      p_History in number /*:=0*/) is
    v_BaseScript clob;
  begin
    select script
      into v_BaseScript
      from smart_script
     where date_history is null
       and smart_class_id = p_ClassID;
    --
    if v_BaseScript <> p_Script then
      update smart_script
         set script = p_Script
       where date_history is null
         and smart_class_id = p_ClassID;
      --сохраним историю
      if v_BaseScript is not null and p_History = 1 then
        SetScript(p_ClassID, v_BaseScript, sysdate);
      end if;
    end if;
  exception
    when no_data_found then
      SetScript(p_ClassID, p_Script);
  end;
  --
end PkgSmartFields;
/
grant execute on PKGSMARTFIELDS to F_SMART_RO_ROLE;
grant execute on PKGSMARTFIELDS to F_SMART_RW_ROLE;


prompt

prompt Creating package body PKG_VARIABLE
prompt ==================================
prompt

create or replace package body PKG_VARIABLE as
  --
  procedure is_var_name(p_var_name in varchar2) is
    l_count number;
  begin
    select 1
      into l_count
      from var_name
     where name = p_var_name;
  exception when NO_DATA_FOUND
            then raise_warning('Неверно указано наименование переменной [' ||
                               p_var_name || ']');
  end;
  --
  procedure set_var_str(p_var_name in varchar2, p_value in varchar2) is
  begin
    update var_value set var_str = p_value where var_name = p_var_name;
    if sql%rowcount = 0 then
      is_var_name(p_var_name);
      insert into var_value
        (var_name, var_str)
      values
        (p_var_name, p_value);
    end if;
  end;
  --
  procedure set_var_num(p_var_name in varchar2, p_value in number) is
  begin
    update var_value set var_num = p_value where var_name = p_var_name;
    if sql%rowcount = 0 then
      is_var_name(p_var_name);
      insert into var_value
        (var_name, var_num)
      values
        (p_var_name, p_value);
    end if;
  end;
  --
  procedure set_var_date(p_var_name in varchar2, p_value in date) is
  begin
    update var_value set var_date = p_value where var_name = p_var_name;
    if sql%rowcount = 0 then
      is_var_name(p_var_name);
      insert into var_value
        (var_name, var_date)
      values
        (p_var_name, p_value);
    end if;
  end;
  --
  procedure clear_var(p_var_name in varchar2) is
  begin
    delete var_value
     where var_name = p_var_name;
  end;
  --
  procedure inc(p_var_name in varchar2) is
  begin
    update var_value
       set var_num = var_num + 1
     where var_name = p_var_name;
    if sql%rowcount = 0 then
      is_var_name(p_var_name);
      insert into var_value
        (var_name, var_num)
      values
        (p_var_name, 1);
    end if;
  end;
  --
  procedure dec(p_var_name in varchar2) is
  begin
    update var_value
       set var_num = var_num - 1
     where var_name = p_var_name
       and var_num > 0;
    if sql%rowcount = 0 then
      is_var_name(p_var_name);
      raise_warning('Ошибка декремента переменной [' ||
                    p_var_name || ']');
    end if;
  end;
  --
  function get_var_str(p_var_name in varchar2) return varchar2 is
    l_result varchar2(4000);
  begin
    is_var_name(p_var_name);
    select var_str
      into l_result
      from var_value
     where var_name = p_var_name;
    return l_result;
  exception
    when no_data_found then
      return null;
  end;
  --
  function get_var_num(p_var_name in varchar2) return number is
    l_result number;
  begin
    is_var_name(p_var_name);
    select var_num
      into l_result
      from var_value
     where var_name = p_var_name;
    return l_result;
  exception
    when no_data_found then
      return null;
  end;
  --
  function get_var_date(p_var_name in varchar2) return date is
    l_result date;
  begin
    is_var_name(p_var_name);
    select var_date
      into l_result
      from var_value
     where var_name = p_var_name;
    return l_result;
  exception
    when no_data_found then
      return null;
  end;
  --
  function get_var_str_silent(p_var_name in varchar2) return varchar2 is
    l_result varchar2(4000);
  begin
    select var_str
      into l_result
      from var_value
     where var_name = p_var_name;
    return l_result;
  exception
    when no_data_found then
      return null;
  end;
  --
  function get_var_num_silent(p_var_name in varchar2) return number is
    l_result number;
  begin
    select var_num
      into l_result
      from var_value
     where var_name = p_var_name;
    return l_result;
  exception
    when no_data_found then
      return null;
  end;
  --
  function get_var_date_silent(p_var_name in varchar2) return date is
    l_result date;
  begin
    select var_date
      into l_result
      from var_value
     where var_name = p_var_name;
    return l_result;
  exception
    when no_data_found then
      return null;
  end;
  --
  procedure create_var(p_var_name varchar2, p_var_note varchar2) is
  begin
    insert into var_name
      (name, note)
    values
      (p_var_name, p_var_note);
  end;
  --
  procedure delete_var(p_var_name varchar2) is
  begin
    delete var_name
     where name = p_var_name;

  end;
  --
end PKG_VARIABLE;
/
grant execute on PKG_VARIABLE to F_SMART_RO_ROLE;


prompt

prompt Creating trigger TIB_DICS
prompt =========================
prompt

create or replace trigger tib_dics before insert
on Dics for each row
begin
   if INSERTING and :NEW.ID is null then
    Select Dics_SEQ.NextVal into :NEW.ID from dual;
   end if;
   :NEW.NEW := 1;
end;
/

prompt

prompt Creating trigger TIB_FILEITEMS
prompt ==============================
prompt

create or replace trigger TIB_FILEITEMS
  before insert or delete or update
  on FILEITEMS
  for each row
declare
begin
  PKGFILESTORAGE.CheckGrant; -- проверим полномочия
end TIB_FILEITEMS;
/

prompt

prompt Creating trigger TIB_FILTERS_ITEMS
prompt ==================================
prompt

CREATE OR REPLACE TRIGGER TIB_FILTERS_ITEMS
BEFORE INSERT
ON FILTERS_ITEMS
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

begin
  if :new.id is null then
    select filters_item_id_seq.nextval into :new.id from dual;
  end if;
end tib_filters_items;
/

prompt

prompt Creating trigger TIB_SMART_AUDIT_EXCEPTIONS_LOG
prompt ===============================================
prompt

CREATE OR REPLACE TRIGGER TIB_SMART_AUDIT_EXCEPTIONS_LOG
BEFORE INSERT
ON SMART_AUDIT_EXCEPTIONS_LOG
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

begin
  if :new.id is null then
    select SMART_AUDIT_EXCEPTIONS_LOG_seq.nextval into :new.id from dual;
  end if;
end tib_SMART_AUDIT_EXCEPTIONS_LOG;
/

prompt

prompt Creating trigger TIB_SMART_DSET_AUDIT_DETAIL
prompt ============================================
prompt

CREATE OR REPLACE TRIGGER TIB_SMART_DSET_AUDIT_DETAIL
BEFORE INSERT
ON SMART_DSET_AUDIT_DETAIL
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW

begin
  if :new.id is null then
    select SMART_DSET_AUDIT_DETAIL_seq.nextval into :new.id from dual;
  end if;
end tib_SMART_DSET_AUDIT_DETAIL;
/

prompt

prompt Creating trigger TIUB_SMART_GRANT
prompt =================================
prompt

create or replace trigger TIUB_smart_grant
  before insert or update on smart_grant
  for each row
declare
begin
  if :new.filter is null then --[+]pimenov_pa 13.08.2010 защшита от кривых клиентов Oracle
    :new.filter := '-';
  end if;
end TIUB_smart_grant;
/

prompt

prompt Creating trigger TIUDB_DICS_TREE
prompt ================================
prompt

CREATE OR REPLACE TRIGGER TIUDB_DICS_TREE
BEFORE INSERT or UPDATE or DELETE
ON DICS_TREE
REFERENCING OLD AS OLD NEW AS NEW
FOR EACH ROW
begin
  if INSERTING then
    if :NEW.ID is null then
      Select Dics_Tree_SEQ.NextVal into :NEW.ID from dual;
    end if;
    if :NEW.USER_FILTER is not null then
      :NEW.USER_FILTER := USER;
    end if;
  end if;
  if deleting then
    if :OLD.DIC_TREE_ID is null and nvl(:old.con_tree_num, 0) = 0 and
       :old.SMART_CLASS_ID is null then
      Raise_warning('Нельзя удалять корневую папку');
      null;
    end if;
  end if;
  if deleting or updating then
    if :new.user_filter <> user and user <> 'PI' then
      Raise_warning('Удалить или изменить невозможно так как набор был создан пользователем <' ||
                    :new.user_filter || '>');
    end if;
  end if;
end;
/

prompt

prompt Creating trigger TIUDB_FILEHEADER
prompt =================================
prompt

create or replace trigger TIUDB_FILEHEADER
  before insert or update or delete on fileheader
  for each row

declare
begin
  PKGFILESTORAGE.CheckGrant; -- проверим полномочия
  if inserting and :NEW.ID is null then
    Select FILEHEADER_SEQ.NextVal into :NEW.ID from dual;
  end if;
  if inserting then
    insert into filehistory
      (filename, filesize, blocksize, con_compress, operation)
    values
      (:new.filename,
       :new.filesize,
       :new.blocksize,
       :new.con_compress,
       'I');
  end if;
end TIUDB_FILEHEADER;
/

prompt

prompt Creating trigger TIUDB_NUM_DICS_TREE
prompt ====================================
prompt

create or replace trigger tiudb_num_dics_tree
before insert or update or delete on Dics_Tree_Item for each row

declare
begin
   if INSERTING and :NEW.ID is null then
    Select Dics_Tree_Item_SEQ.NextVal into :NEW.ID from dual;
   end if;
end;
/

prompt

prompt Creating trigger TIUDB_SMART_CLASS
prompt ==================================
prompt

create or replace trigger TIUDB_SMART_CLASS
  before insert or update or delete on SMART_CLASS
  for each row
declare
begin
  if inserting then
    if :new.id is null then
      select SMART_CLASS_SEQ.nextval into :new.id from dual;
    end if;
    if :new.tag_id is null then
      :new.tag_id := :new.id;
    end if;
  end if;
end TIUDB_SMART_CLASS;
/

prompt

prompt Creating trigger TIUDB_SMART_DSET
prompt =================================
prompt

create or replace trigger TIUDB_SMART_DSET
  before insert or update or delete on SMART_DSET
  for each row
declare
begin
  if inserting and :new.id is null then
    select SMART_DSET_SEQ.nextval into :new.id from dual;
  end if;
  if inserting then
    if :new.con_class_type <> 1 then
      :new.is_delete_class := 1;
    end if;
  end if;
  if deleting then
    if :old.is_delete_class = 1 then
      raise_warning_silien('Класс запрещен от удаления (используется в клиенте)');
    end if;
  end if;
end TIUDB_SMART_DSET;
/

prompt

prompt Creating trigger TIUDB_SMART_SCRIPT
prompt ===================================
prompt

create or replace trigger TIUDB_SMART_SCRIPT
  before insert or update or delete on SMART_SCRIPT
  for each row
declare
begin
  if inserting and :new.id is null then
    select SMART_SCRIPT_SEQ.nextval into :new.id from dual;
  end if;
end TIUDB_SMART_SCRIPT;
/

prompt

prompt Creating trigger TIUDB_SMART_SETTINGS
prompt =====================================
prompt

create or replace trigger TIUDB_SMART_SETTINGS
  before insert or update or delete on SMART_SETTINGS
  for each row
declare
begin
  if inserting and :new.id is null then
    select SMART_SETTINGS_SEQ.nextval into :new.id from dual;
  end if;
end TIUDB_SMART_SETTINGS;
/

insert into SMART_AUDIT_CONFIG
(look_schemes, 
admin_email, 
instance_name, 
work_schema, 
about
)
values
('''CP'',''INS''',
'mihail.chenryh@renlife.com',
'PROD_TEST',
'CP',
'Модуль'
);


insert into 
SMART_AUDIT_APP
(appcode, 
note, 
name, 
exename, 
lastbuild, 
tree_number, 
min_valid_build, 
icon_index, 
delay_sql_trace
)
values
(105, 
'SMART', 
'SMART', 
'SMART.exe', 
32455, 
null, 
null, 
null, 
0);

DECLARE
  v_curr_val NUMBER;
  v_next_val NUMBER;
BEGIN
  /*1*/
  SELECT smart_class_seq.nextval INTO v_curr_val FROM dual;
  SELECT MAX(t.id) + 1 INTO v_next_val FROM smart_class t;

  EXECUTE IMMEDIATE 'ALTER sequence smart_class_seq increment BY ' || to_char(v_next_val - v_curr_val) ||
                    ' nocache';
  SELECT smart_class_seq.nextval INTO v_curr_val FROM dual;
  EXECUTE IMMEDIATE 'alter sequence smart_class_seq increment by 1 cache 20';
  
  
END;
/
DECLARE
  v_curr_val NUMBER;
  v_next_val NUMBER;
BEGIN
  /*1*/
  SELECT SMART_SCRIPT_seq.nextval INTO v_curr_val FROM dual;
  SELECT MAX(t.id) + 1 INTO v_next_val FROM SMART_SCRIPT t;

  EXECUTE IMMEDIATE 'ALTER sequence SMART_SCRIPT_seq increment BY ' || to_char(v_next_val - v_curr_val) ||
                    ' nocache';
  SELECT SMART_SCRIPT_seq.nextval INTO v_curr_val FROM dual;
  EXECUTE IMMEDIATE 'alter sequence SMART_SCRIPT_seq increment by 1 cache 20';
  
  
END;
/
DECLARE
  v_curr_val NUMBER;
  v_next_val NUMBER;
BEGIN
  /*1*/
  SELECT SMART_DSET_seq.nextval INTO v_curr_val FROM dual;
  SELECT MAX(t.id) + 1 INTO v_next_val FROM SMART_DSET t;

  EXECUTE IMMEDIATE 'ALTER sequence SMART_DSET_seq increment BY ' || to_char(v_next_val - v_curr_val) ||
                    ' nocache';
  SELECT SMART_DSET_seq.nextval INTO v_curr_val FROM dual;
  EXECUTE IMMEDIATE 'alter sequence SMART_DSET_seq increment by 1 cache 20';
  
  
END;
/

commit;
spool off
