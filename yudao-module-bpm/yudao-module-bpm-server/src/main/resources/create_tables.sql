DROP TABLE IF EXISTS `bpm_process_expression`;
CREATE TABLE bpm_process_expression (
    `id`              BIGINT NOT NULL AUTO_INCREMENT COMMENT '编号',
    `name`            VARCHAR(255) NOT NULL COMMENT '表达式名字',
    `status`          TINYINT NOT NULL COMMENT '表达式状态',
    `expression`      VARCHAR(1024) NOT NULL COMMENT '表达式',

-- BaseDO 通用字段
    `creator`      varchar(64) DEFAULT NULL COMMENT '创建者',
    `create_time`  datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`      varchar(64) DEFAULT NULL COMMENT '更新者',
    `update_time`  datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`      BIT(1) DEFAULT b'0' COMMENT '是否删除（逻辑删）',
    `tenant_id`    bigint DEFAULT '0' COMMENT '租户编号',

    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='流程表达式表';

DROP TABLE IF EXISTS `bpm_process_listener`;
CREATE TABLE `bpm_process_listener` (
    `id`           bigint NOT NULL AUTO_INCREMENT COMMENT '主键 ID，自增',
    `name`         varchar(255) DEFAULT NULL COMMENT '监听器名字',
    `status`       int DEFAULT NULL COMMENT '状态（CommonStatusEnum）',
    `type`         varchar(50) DEFAULT NULL COMMENT '监听类型（execution / task）',
    `event`        varchar(100) DEFAULT NULL COMMENT '监听事件(execution 时：start、end; task 时：create 创建、assignment 指派、complete 完成、delete 删除、update 更新、timeout 超时)',
    `value_type`   varchar(50) DEFAULT NULL COMMENT '值类型（class / delegateExpression / expression）',
    `value`        varchar(500) DEFAULT NULL COMMENT '值',

    -- BaseDO 通用字段
    `creator`      varchar(64) DEFAULT NULL COMMENT '创建者',
    `create_time`  datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater`      varchar(64) DEFAULT NULL COMMENT '更新者',
    `update_time`  datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted`      BIT(1) DEFAULT b'0' COMMENT '是否删除（逻辑删）',
    `tenant_id`    bigint DEFAULT '0' COMMENT '租户编号',

    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 流程监听器';


DROP TABLE IF EXISTS `bpm_process_definition_info`;
CREATE TABLE `bpm_process_definition_info` (
   `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '编号',
   `process_definition_id` VARCHAR(64) DEFAULT NULL COMMENT '流程定义的编号',
   `model_id` VARCHAR(64) DEFAULT NULL COMMENT '流程模型的编号',
   `model_type` INT DEFAULT NULL COMMENT '流程模型的类型',
   `category` VARCHAR(64) DEFAULT NULL COMMENT '流程分类编码',
   `icon` VARCHAR(255) DEFAULT NULL COMMENT '图标',
   `description` VARCHAR(1024) DEFAULT NULL COMMENT '描述',

   `form_type` INT DEFAULT NULL COMMENT '表单类型',
   `form_id` BIGINT DEFAULT NULL COMMENT '动态表单编号',
   `form_conf` LONGTEXT COMMENT '表单配置（冗余 BpmFormDO.conf）',
   `form_fields` JSON DEFAULT NULL COMMENT '表单项数组（冗余 BpmFormDO.fields）',

   `form_custom_create_path` VARCHAR(255) DEFAULT NULL COMMENT '自定义表单创建路径（Vue 路由地址）',
   `form_custom_view_path` VARCHAR(255) DEFAULT NULL COMMENT '自定义表单查看路径（Vue 路由地址）',

   `simple_model` LONGTEXT COMMENT 'SIMPLE 设计器模型数据 JSON',
   `visible` TINYINT(1) DEFAULT 1 COMMENT '是否可见, 1 表示 true, 0 表示 false',
   `sort` BIGINT DEFAULT 0 COMMENT '排序值',

   `start_user_ids` VARCHAR(255) DEFAULT NULL COMMENT '可发起用户编号数组',
   `start_dept_ids` VARCHAR(255) DEFAULT NULL COMMENT '可发起部门编号数组',
   `manager_user_ids` VARCHAR(255) DEFAULT NULL COMMENT '可管理用户编号数组',

   `allow_cancel_running_process` TINYINT(1) DEFAULT 1 COMMENT '是否允许撤销审批中申请, 1 表示 true, 0 表示 false',
   `allow_withdraw_task` TINYINT(1) DEFAULT 1 COMMENT '是否允许审批人撤回任务,  1 表示 true, 0 表示 false',

   `process_id_rule` JSON DEFAULT NULL COMMENT '流程 ID 规则',
   `auto_approval_type` INT DEFAULT NULL COMMENT '自动去重类型',
   `title_setting` JSON DEFAULT NULL COMMENT '标题设置',
   `summary_setting` JSON DEFAULT NULL COMMENT '摘要设置',
   `process_before_trigger_setting` JSON DEFAULT NULL COMMENT '流程前置通知设置',
   `process_after_trigger_setting` JSON DEFAULT NULL COMMENT '流程后置通知设置',
   `task_before_trigger_setting` JSON DEFAULT NULL COMMENT '任务前置通知设置',
   `task_after_trigger_setting` JSON DEFAULT NULL COMMENT '任务后置通知设置',

    -- BaseDO 通用字段（假设包含）
   `creator` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
   `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
   `updater` VARCHAR(64) DEFAULT NULL COMMENT '更新人',
   `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
   `deleted` BIT(1) DEFAULT b'0' COMMENT '是否删除',
   `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
   PRIMARY KEY (`id`),
   KEY `idx_model_id` (`model_id`),
   KEY `idx_process_definition_id` (`process_definition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='BPM 流程定义扩展信息表';


DROP TABLE IF EXISTS `bpm_oa_leave`;
CREATE TABLE `bpm_oa_leave` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '请假表单主键',
    `user_id` BIGINT NOT NULL COMMENT '申请人的用户编号，关联 AdminUserDO 的 id 属性',
    `type` VARCHAR(50) NOT NULL COMMENT '请假类型',
    `reason` VARCHAR(500) DEFAULT NULL COMMENT '原因',
    `start_time` DATETIME NOT NULL COMMENT '开始时间',
    `end_time` DATETIME NOT NULL COMMENT '结束时间',
    `day` BIGINT DEFAULT NULL COMMENT '请假天数',
    `status` INT DEFAULT NULL COMMENT '审批结果，对应 BpmTaskStatusEnum 或 BpmProcessInstanceStatusEnum',
    `process_instance_id` VARCHAR(64) DEFAULT NULL COMMENT '对应的流程编号，关联 ProcessInstance 的 id 属性',
    `creator` VARCHAR(64) DEFAULT NULL COMMENT '创建人',
    `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    `updater` VARCHAR(64) DEFAULT NULL COMMENT '更新人',
    `update_time` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    `deleted` BIT(1) DEFAULT b'0' COMMENT '是否删除',
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='OA 请假表单';


DROP TABLE IF EXISTS `bpm_user_group`;
CREATE TABLE IF NOT EXISTS `bpm_user_group` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '用户组主键',
    `name` varchar(63) NOT NULL,
    `description` varchar(255) NOT NULL,
    `status` tinyint NOT NULL,
    `user_ids` varchar(255) NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit NOT NULL DEFAULT FALSE,
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`)
) COMMENT '用户组';

DROP TABLE IF EXISTS `bpm_category`;
CREATE TABLE IF NOT EXISTS `bpm_category` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '分类主键',
    `name` varchar(63) NOT NULL,
    `code` varchar(63) NOT NULL,
    `description` varchar(255) NOT NULL,
    `status` tinyint NOT NULL,
    `sort` int NOT NULL,
    `creator` varchar(64) DEFAULT '',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit NOT NULL DEFAULT FALSE,
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`)
) COMMENT '分类';

DROP TABLE IF EXISTS `bpm_form`;
CREATE TABLE IF NOT EXISTS `bpm_form` (
    `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT '动态表单主键',
    `name` varchar(63) NOT NULL,
    `status` tinyint NOT NULL,
    `fields` varchar(255) NOT NULL,
    `conf` varchar(255) NOT NULL,
    `remark` varchar(255),
    `creator` varchar(64) DEFAULT '',
    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updater` varchar(64) DEFAULT '',
    `update_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `deleted` bit NOT NULL DEFAULT FALSE,
    `tenant_id` bigint NOT NULL DEFAULT 0 COMMENT '租户编号',
    PRIMARY KEY (`id`)
) COMMENT '动态表单';
