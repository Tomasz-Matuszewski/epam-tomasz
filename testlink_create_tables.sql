# TestLink Open Source Project - http://testlink.sourceforge.net/
# This script is distributed under the GNU General Public License 2 or later.
# ---------------------------------------------------------------------------------------
# @filesource testlink_create_tables.sql
#
# SQL script - create all DB tables for MySQL
# tables are in alphabetic order  
#
# ATTENTION: do not use a different naming convention, that one already in use.
#
# IMPORTANT NOTE:
# each NEW TABLE added here NEED TO BE DEFINED in object.class.php getDBTables()
#
# IMPORTANT NOTE - DATETIME or TIMESTAMP
# Extracted from MySQL Manual
#
# The TIMESTAMP column type provides a type that you can use to automatically 
# mark INSERT or UPDATE operations with the current date and time. 
# If you have multiple TIMESTAMP columns in a table, only the first one is updated automatically.
#
# Knowing this is clear that we can use in interchangable way DATETIME or TIMESTAMP
#
# Naming convention for column regarding date/time of creation or change
#
# Right or wrong from TL 1.7 we have used
#
# creation_ts
# modification_ts
#
# Then no other naming convention has to be used as:
# create_ts, modified_ts
#
# CRITIC:
# Because this file will be processed during installation doing text replaces
# to add TABLE PREFIX NAME, any NEW DDL CODE added must be respect present
# convention regarding case and spaces between DDL keywords.
# 
# ---------------------------------------------------------------------------------------
# @internal revisions
#
# ---------------------------------------------------------------------------------------


CREATE TABLE /*prefix*/assignment_types (
  `id` int(10) unsigned NOT NULL auto_increment,
  `fk_table` varchar(30) default '',
  `description` varchar(100) NOT NULL default 'unknown',
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/assignment_status (
  `id` int(10) unsigned NOT NULL auto_increment,
  `description` varchar(100) NOT NULL default 'unknown',
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/attachments (
  `id` int(10) unsigned NOT NULL auto_increment,
  `fk_id` int(10) unsigned NOT NULL default '0',
  `fk_table` varchar(250) default '',
  `title` varchar(250) default '',
  `description` varchar(250) default '',
  `file_name` varchar(250) NOT NULL default '',
  `file_path` varchar(250) default '',
  `file_size` int(11) NOT NULL default '0',
  `file_type` varchar(250) NOT NULL default '',
  `date_added` TIMESTAMP NOT NULL default  CURRENT_TIMESTAMP,
  `content` longblob,
  `compression_type` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`),
  KEY /*prefix*/attachments_idx1(fk_id)
) DEFAULT CHARSET=utf8; 


CREATE TABLE /*prefix*/builds (
  `id` int(10) unsigned NOT NULL auto_increment,
  `testplan_id` int(10) unsigned NOT NULL default '0',
  `name` varchar(100) NOT NULL default 'undefined',
  `notes` text,
  `active` tinyint(1) NOT NULL default '1',
  `is_open` tinyint(1) NOT NULL default '1',
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `release_date` date NULL,
  `closed_on_date` date NULL,
  `commit_id` varchar(64) NULL,
  `tag` varchar(64) NULL,
  `branch` varchar(64) NULL,
  `release_candidate` varchar(100),
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/name (`testplan_id`,`name`),
  KEY /*prefix*/testplan_id (`testplan_id`)
) DEFAULT CHARSET=utf8 COMMENT='Available builds';


CREATE TABLE /*prefix*/cfield_build_design_values (
  `field_id` int(10) NOT NULL default '0',
  `node_id` int(10) NOT NULL default '0',
  `value` varchar(4000) NOT NULL default '',
  PRIMARY KEY  (`field_id`,`node_id`),
  KEY /*prefix*/idx_cfield_build_design_values (`node_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/cfield_design_values (
  `field_id` int(10) NOT NULL default '0',
  `node_id` int(10) NOT NULL default '0',
  `value` varchar(4000) NOT NULL default '',
  PRIMARY KEY  (`field_id`,`node_id`),
  KEY /*prefix*/idx_cfield_design_values (`node_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/cfield_execution_values (
  `field_id`     int(10) NOT NULL default '0',
  `execution_id` int(10) NOT NULL default '0',
  `testplan_id` int(10) NOT NULL default '0',
  `tcversion_id` int(10) NOT NULL default '0',
  `value` varchar(4000) NOT NULL default '',
  PRIMARY KEY  (`field_id`,`execution_id`,`testplan_id`,`tcversion_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/cfield_node_types (
  `field_id` int(10) NOT NULL default '0',
  `node_type_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`field_id`,`node_type_id`),
  KEY /*prefix*/idx_custom_fields_assign (`node_type_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/cfield_testprojects (
  `field_id` int(10) unsigned NOT NULL default '0',
  `testproject_id` int(10) unsigned NOT NULL default '0',
  `display_order` smallint(5) unsigned NOT NULL default '1',
  `location` smallint(5) unsigned NOT NULL default '1',
  `active` tinyint(1) NOT NULL default '1',
  `required` tinyint(1) NOT NULL default '0',
  `required_on_design` tinyint(1) NOT NULL default '0',
  `required_on_execution` tinyint(1) NOT NULL default '0',
  `monitorable` tinyint(1) NOT NULL default '0',
  PRIMARY KEY  (`field_id`,`testproject_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/cfield_testplan_design_values (
  `field_id` int(10) NOT NULL default '0',
  `link_id` int(10) NOT NULL default '0' COMMENT 'point to testplan_tcversion id',   
  `value` varchar(4000) NOT NULL default '',
  PRIMARY KEY  (`field_id`,`link_id`),
  KEY /*prefix*/idx_cfield_tplan_design_val (`link_id`)
) DEFAULT CHARSET=utf8;


# new fields to display custom fields in new areas
# test case linking to testplan (test plan design)
CREATE TABLE /*prefix*/custom_fields (
  `id` int(10) NOT NULL auto_increment,
  `name` varchar(64) NOT NULL default '',
  `label` varchar(64) NOT NULL default '' COMMENT 'label to display on user interface' ,
  `type` smallint(6) NOT NULL default '0',
  `possible_values` varchar(4000) NOT NULL default '',
  `default_value` varchar(4000) NOT NULL default '',
  `valid_regexp` varchar(255) NOT NULL default '',
  `length_min` int(10) NOT NULL default '0',
  `length_max` int(10) NOT NULL default '0',
  `show_on_design` tinyint(3) unsigned NOT NULL default '1' COMMENT '1=> show it during specification design',
  `enable_on_design` tinyint(3) unsigned NOT NULL default '1' COMMENT '1=> user can write/manage it during specification design',
  `show_on_execution` tinyint(3) unsigned NOT NULL default '0' COMMENT '1=> show it during test case execution',
  `enable_on_execution` tinyint(3) unsigned NOT NULL default '0' COMMENT '1=> user can write/manage it during test case execution',
  `show_on_testplan_design` tinyint(3) unsigned NOT NULL default '0' ,
  `enable_on_testplan_design` tinyint(3) unsigned NOT NULL default '0' ,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/idx_custom_fields_name (`name`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/db_version (
  `version` varchar(50) NOT NULL default 'unknown',
  `upgrade_ts` TIMESTAMP NOT NULL default  CURRENT_TIMESTAMP,
  `notes` text,
  PRIMARY KEY  (`version`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/events (
  `id` int(10) unsigned NOT NULL auto_increment,
  `transaction_id` int(10) unsigned NOT NULL default '0',
  `log_level` smallint(5) unsigned NOT NULL default '0',
  `source` varchar(45) default NULL,
  `description` text NOT NULL,
  `fired_at` int(10) unsigned NOT NULL default '0',
  `activity` varchar(45) default NULL,
  `object_id` int(10) unsigned default NULL,
  `object_type` varchar(45) default NULL,
  PRIMARY KEY  (`id`),
  KEY /*prefix*/transaction_id (`transaction_id`),
  KEY /*prefix*/fired_at (`fired_at`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/execution_bugs (
  `execution_id` int(10) unsigned NOT NULL default '0',
  `bug_id` varchar(64) NOT NULL default '0',
  `tcstep_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`execution_id`,`bug_id`,`tcstep_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testcase_script_links (
  `tcversion_id` int(10) unsigned NOT NULL default '0',
  `project_key` varchar(64) NOT NULL,
  `repository_name` varchar(64) NOT NULL,
  `code_path` varchar(255) NOT NULL,
  `branch_name` varchar(64) default NULL,
  `commit_id` varchar(40) default NULL,
  PRIMARY KEY  (`tcversion_id`,`project_key`,`repository_name`,`code_path`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/executions (
  id int(10) unsigned NOT NULL auto_increment,
  build_id int(10) NOT NULL default '0',
  tester_id int(10) unsigned default NULL,
  execution_ts datetime default NULL,
  status char(1) default NULL,
  testplan_id int(10) unsigned NOT NULL default '0',
  tcversion_id int(10) unsigned NOT NULL default '0',
  tcversion_number smallint(5) unsigned NOT NULL default '1',
  platform_id int(10) unsigned NOT NULL default '0',
  execution_type tinyint(1) NOT NULL default '1' COMMENT '1 -> manual, 2 -> automated',
  execution_duration decimal(6,2) NULL COMMENT 'NULL will be considered as NO DATA Provided by user',
  notes text,
  PRIMARY KEY  (id),
  KEY /*prefix*/executions_idx1(testplan_id,tcversion_id,platform_id,build_id),
  KEY /*prefix*/executions_idx2(execution_type),
  KEY /*prefix*/executions_idx3(tcversion_id)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/execution_tcsteps (
   id int(10) unsigned NOT NULL auto_increment,
   execution_id int(10) unsigned NOT NULL default '0',
   tcstep_id int(10) unsigned NOT NULL default '0',
   notes text,
   status char(1) default NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY /*prefix*/execution_tcsteps_idx1(`execution_id`,`tcstep_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/execution_tcsteps_wip (
   id int(10) unsigned NOT NULL auto_increment,
   tcstep_id int(10) unsigned NOT NULL default '0',
   testplan_id int(10) unsigned NOT NULL default '0',
   platform_id int(10) unsigned NOT NULL default '0',
   build_id int(10) unsigned NOT NULL default '0',
   tester_id int(10) unsigned default NULL,
   creation_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   notes text,
   status char(1) default NULL,
  PRIMARY KEY  (id),
  UNIQUE KEY /*prefix*/execution_tcsteps_wip_idx1(`tcstep_id`,`testplan_id`,`platform_id`,`build_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/inventory (
  id int(10) unsigned NOT NULL auto_increment,
	`testproject_id` INT( 10 ) UNSIGNED NOT NULL ,
	`owner_id` INT(10) UNSIGNED NOT NULL ,
	`name` VARCHAR(255) NOT NULL ,
	`ipaddress` VARCHAR(255)  NOT NULL ,
	`content` TEXT NULL ,
	`creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`modification_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	PRIMARY KEY (`id`),
	KEY /*prefix*/inventory_idx1 (`testproject_id`)
) DEFAULT CHARSET=utf8; 


CREATE TABLE /*prefix*/keywords (
  `id` int(10) unsigned NOT NULL auto_increment,
  `keyword` varchar(100) NOT NULL default '',
  `testproject_id` int(10) unsigned NOT NULL default '0',
  `notes` text,
  PRIMARY KEY  (`id`),
  KEY /*prefix*/testproject_id (`testproject_id`),
  KEY /*prefix*/keyword (`keyword`),
  UNIQUE KEY /*prefix*/keyword_testproject_id (`keyword`,`testproject_id`)  
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/milestones (
  id int(10) unsigned NOT NULL auto_increment,
  testplan_id int(10) unsigned NOT NULL default '0',
  target_date date NOT NULL,
  start_date date NULL,
  a tinyint(3) unsigned NOT NULL default '0',
  b tinyint(3) unsigned NOT NULL default '0',
  c tinyint(3) unsigned NOT NULL default '0',
  name varchar(100) NOT NULL default 'undefined',
  PRIMARY KEY  (id),
  KEY /*prefix*/testplan_id (`testplan_id`),
  UNIQUE KEY /*prefix*/name_testplan_id (`name`,`testplan_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/node_types (
  `id` int(10) unsigned NOT NULL auto_increment,
  `description` varchar(100) NOT NULL default 'testproject',
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/nodes_hierarchy (
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(100) default NULL,
  `parent_id` int(10) unsigned default NULL,
  `node_type_id` int(10) unsigned NOT NULL default '1',
  `node_order` int(10) unsigned default NULL,
  PRIMARY KEY  (`id`),
  KEY /*prefix*/pid_m_nodeorder (`parent_id`,`node_order`),
  KEY /*prefix*/nodes_hierarchy_node_type_id (`node_type_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/platforms (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(100) NOT NULL,
  testproject_id int(10) UNSIGNED NOT NULL,
  notes text NOT NULL,
  enable_on_design tinyint(1) unsigned NOT NULL default '0',
  enable_on_execution tinyint(1) unsigned NOT NULL default '1',
  PRIMARY KEY (id),
  UNIQUE KEY /*prefix*/idx_platforms (testproject_id,name)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/req_coverage (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `req_id` int(10) NOT NULL,
  `req_version_id` int(10) NOT NULL,
  `testcase_id` int(10) NOT NULL,
  `tcversion_id` int(10) NOT NULL,
  `link_status` int(11) NOT NULL DEFAULT '1',
  `is_active` int(11) NOT NULL DEFAULT '1',
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `review_requester_id` int(10) unsigned default NULL,
  `review_request_ts` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY /*prefix*/req_coverage_full_link (`req_id`,`req_version_id`,`testcase_id`,`tcversion_id`)
) DEFAULT CHARSET=utf8 COMMENT='relation test case version ** requirement version';


CREATE TABLE /*prefix*/req_specs (
  `id` int(10) unsigned NOT NULL,
  `testproject_id` int(10) unsigned NOT NULL,
  `doc_id` varchar(64) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY /*prefix*/testproject_id (`testproject_id`),
  UNIQUE KEY /*prefix*/req_spec_uk1(`doc_id`,`testproject_id`)
) DEFAULT CHARSET=utf8 COMMENT='Dev. Documents (e.g. System Requirements Specification)';

CREATE TABLE /*prefix*/requirements (
  `id` int(10) unsigned NOT NULL,
  `srs_id` int(10) unsigned NOT NULL,
  `req_doc_id` varchar(64) NOT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/requirements_req_doc_id (`srs_id`,`req_doc_id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/req_versions (
  `id` int(10) unsigned NOT NULL,
  `version` smallint(5) unsigned NOT NULL default '1',
  `revision` smallint(5) unsigned NOT NULL default '1', 
  `scope` text,
  `status` char(1) NOT NULL default 'V',
  `type` char(1) default NULL,
  `active` tinyint(1) NOT NULL default '1',
  `is_open` tinyint(1) NOT NULL default '1',
  `expected_coverage` int(10) NOT NULL default '1',
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifier_id` int(10) unsigned default NULL,
  `modification_ts` datetime NOT NULL default CURRENT_TIMESTAMP,
  `log_message` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/req_relations (
  `id` int(10) unsigned NOT NULL auto_increment,
  `source_id` int(10) unsigned NOT NULL,
  `destination_id` int(10) unsigned NOT NULL,
  `relation_type` smallint(5) unsigned NOT NULL default '1',
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/rights (
  `id` int(10) unsigned NOT NULL auto_increment,
  `description` varchar(100) NOT NULL default '',
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/rights_descr (`description`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/risk_assignments (
  `id` int(10) unsigned NOT NULL auto_increment,
  `testplan_id` int(10) unsigned NOT NULL default '0',
  `node_id` int(10) unsigned NOT NULL default '0',
  `risk` char(1) NOT NULL default '2',
  `importance` char(1) NOT NULL default 'M',
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/risk_assignments_tplan_node_id (`testplan_id`,`node_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/role_rights (
  `role_id` int(10) NOT NULL default '0',
  `right_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`role_id`,`right_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/roles (
  `id` int(10) unsigned NOT NULL auto_increment,
  `description` varchar(100) NOT NULL default '',
  `notes` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/role_rights_roles_descr (`description`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testcase_keywords (
  `id` int(10) unsigned NOT NULL auto_increment,
  `testcase_id` int(10) unsigned NOT NULL default '0',
  `tcversion_id` int(10) unsigned NOT NULL default '0', 
  `keyword_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/idx01_testcase_keywords (`testcase_id`,`tcversion_id`,`keyword_id`),
  KEY /*prefix*/idx02_testcase_keywords (`tcversion_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/tcversions (
  `id` int(10) unsigned NOT NULL,
  `tc_external_id` int(10) unsigned NULL,
  `version` smallint(5) unsigned NOT NULL default '1',
  `layout` smallint(5) unsigned NOT NULL default '1',
  `status` smallint(5) unsigned NOT NULL default '1',
  `summary` text,
  `preconditions` text,
  `importance` smallint(5) unsigned NOT NULL default '2',
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updater_id` int(10) unsigned default NULL,
  `modification_ts` datetime NOT NULL default  CURRENT_TIMESTAMP,
  `active` tinyint(1) NOT NULL default '1',
  `is_open` tinyint(1) NOT NULL default '1',
  `execution_type` tinyint(1) NOT NULL default '1' COMMENT '1 -> manual, 2 -> automated',
  `estimated_exec_duration` decimal(6,2) NULL COMMENT 'NULL will be considered as NO DATA Provided by user',
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/tcsteps (  
  id int(10) unsigned NOT NULL,
  step_number INT NOT NULL DEFAULT '1',
  actions TEXT,
  expected_results TEXT,
  active tinyint(1) NOT NULL default '1',
  execution_type tinyint(1) NOT NULL default '1' COMMENT '1 -> manual, 2 -> automated',
  PRIMARY KEY (id)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testplan_tcversions (
  id int(10) unsigned NOT NULL auto_increment,
  testplan_id int(10) unsigned NOT NULL default '0',
  tcversion_id int(10) unsigned NOT NULL default '0',
  node_order int(10) unsigned NOT NULL default '1',
  urgency smallint(5) NOT NULL default '2',
  platform_id int(10) unsigned NOT NULL default '0',
  author_id int(10) unsigned default NULL,
  creation_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (id),
  UNIQUE KEY /*prefix*/testplan_tcversions_tplan_tcversion (testplan_id,tcversion_id,platform_id)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testplans (
  `id` int(10) unsigned NOT NULL,
  `testproject_id` int(10) unsigned NOT NULL default '0',
  `notes` text,
  `active` tinyint(1) NOT NULL default '1',
  `is_open` tinyint(1) NOT NULL default '1',
  `is_public` tinyint(1) NOT NULL default '1',
  `api_key` varchar(64) NOT NULL default '829a2ded3ed0829a2dedd8ab81dfa2c77e8235bc3ed0d8ab81dfa2c77e8235bc',
  PRIMARY KEY  (`id`),
  KEY /*prefix*/testplans_testproject_id_active (`testproject_id`,`active`),
  UNIQUE KEY /*prefix*/testplans_api_key (`api_key`) 
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testplan_platforms (
  id int(10) unsigned NOT NULL auto_increment,
  testplan_id int(10) unsigned NOT NULL,
  platform_id int(10) unsigned NOT NULL,
  active tinyint(1) NOT NULL default '1',
  PRIMARY KEY (id),
  UNIQUE KEY /*prefix*/idx_testplan_platforms(testplan_id,platform_id)
) DEFAULT CHARSET=utf8 COMMENT='Connects a testplan with platforms';


CREATE TABLE /*prefix*/testprojects (
  `id` int(10) unsigned NOT NULL,
  `notes` text,
  `color` varchar(12) NOT NULL default '#9BD',
  `active` tinyint(1) NOT NULL default '1',
  `option_reqs` tinyint(1) NOT NULL default '0',
  `option_priority` tinyint(1) NOT NULL default '0',
  `option_automation` tinyint(1) NOT NULL default '0',  
  `options` text,
  `prefix` varchar(16) NOT NULL,
  `tc_counter` int(10) unsigned NOT NULL default '0',
  `is_public` tinyint(1) NOT NULL default '1',
  `issue_tracker_enabled` tinyint(1) NOT NULL default '0',
  `code_tracker_enabled` tinyint(1) NOT NULL default '0',
  `reqmgr_integration_enabled` tinyint(1) NOT NULL default '0',
  `api_key` varchar(64) NOT NULL default '0d8ab81dfa2c77e8235bc829a2ded3edfa2c78235bc829a27eded3ed0d8ab81d',
  PRIMARY KEY  (`id`),
  KEY /*prefix*/testprojects_id_active (`id`,`active`),
  UNIQUE KEY /*prefix*/testprojects_prefix (`prefix`),
  UNIQUE KEY /*prefix*/testprojects_api_key (`api_key`) 
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testsuites (
  `id` int(10) unsigned NOT NULL,
  `details` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/transactions (
  `id` int(10) unsigned NOT NULL auto_increment,
  `entry_point` varchar(45) NOT NULL default '',
  `start_time` int(10) unsigned NOT NULL default '0',
  `end_time` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned NOT NULL default '0',
  `session_id` varchar(45) default NULL,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/user_assignments (
  `id` int(10) unsigned NOT NULL auto_increment,
  `type` int(10) unsigned NOT NULL default '1',
  `feature_id` int(10) unsigned NOT NULL default '0',
  `user_id` int(10) unsigned default '0',
  `build_id` int(10) unsigned default '0',
  `deadline_ts` datetime NULL,
  `assigner_id`  int(10) unsigned default '0',
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` int(10) unsigned default '1',
  PRIMARY KEY  (`id`),
  KEY /*prefix*/user_assignments_feature_id (`feature_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/users (
  `id` int(10) unsigned NOT NULL auto_increment,
  `login` varchar(100) NOT NULL default '',
  `password` varchar(255) NOT NULL default '',
  `role_id` int(10) unsigned NOT NULL default '0',
  `email` varchar(100) NOT NULL default '',
  `first` varchar(50) NOT NULL default '',
  `last` varchar(50) NOT NULL default '',
  `locale` varchar(10) NOT NULL default 'en_GB',
  `default_testproject_id` int(10) default NULL,
  `active` tinyint(1) NOT NULL default '1',
  `script_key` varchar(32) NULL,
  `cookie_string` varchar(64) NOT NULL default '',
  `auth_method` varchar(10) NULL default '',
  `creation_ts` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expiration_date` date DEFAULT NULL,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/users_login (`login`),
  UNIQUE KEY /*prefix*/users_cookie_string (`cookie_string`)
) DEFAULT CHARSET=utf8 COMMENT='User information';


CREATE TABLE /*prefix*/user_testproject_roles (
  `user_id` int(10) NOT NULL default '0',
  `testproject_id` int(10) NOT NULL default '0',
  `role_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`user_id`,`testproject_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/user_testplan_roles (
  `user_id` int(10) NOT NULL default '0',
  `testplan_id` int(10) NOT NULL default '0',
  `role_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`user_id`,`testplan_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/object_keywords (
  `id` int(10) unsigned NOT NULL auto_increment,
  `fk_id` int(10) unsigned NOT NULL default '0',
  `fk_table` varchar(30) default '',
  `keyword_id` int(10) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/udx01_object_keywords (`fk_id`,`fk_table`,`keyword_id`)    
) DEFAULT CHARSET=utf8; 


# not used - group users for large companies 
CREATE TABLE /*prefix*/user_group (
  `id` int(10) unsigned NOT NULL auto_increment,
  `title` varchar(100) NOT NULL,
  `description` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/idx_user_group (`title`)
) DEFAULT CHARSET=utf8;


# not used - group users for large companies 
CREATE TABLE /*prefix*/user_group_assign (
  `usergroup_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  UNIQUE KEY /*prefix*/idx_user_group_assign (`usergroup_id`,`user_id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/req_revisions (
  `parent_id` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `revision` smallint(5) unsigned NOT NULL default '1',
  `req_doc_id` varchar(64) NULL,   /* it's OK to allow a simple update query on code */
  `name` varchar(100) NULL,
  `scope` text,
  `status` char(1) NOT NULL default 'V',
  `type` char(1) default NULL,
  `active` tinyint(1) NOT NULL default '1',
  `is_open` tinyint(1) NOT NULL default '1',
  `expected_coverage` int(10) NOT NULL default '1',
  `log_message` text,
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifier_id` int(10) unsigned default NULL,
  `modification_ts` datetime NOT NULL default  CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/req_revisions_uidx1 (`parent_id`,`revision`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/req_specs_revisions (
  `parent_id` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `revision` smallint(5) unsigned NOT NULL default '1',
  `doc_id` varchar(64) NULL,   /* it's OK to allow a simple update query on code */
  `name` varchar(100) NULL,
  `scope` text,
  `total_req` int(10) NOT NULL default '0',  
  `status` int(10) unsigned default '1',
  `type` char(1) default NULL,
  `log_message` text,
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modifier_id` int(10) unsigned default NULL,
  `modification_ts` datetime NOT NULL default  CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/req_specs_revisions_uidx1 (`parent_id`,`revision`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/issuetrackers
(
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `type` int(10) default 0,
  `cfg` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/issuetrackers_uidx1 (`name`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testproject_issuetracker
(
  `testproject_id` int(10) unsigned NOT NULL,
  `issuetracker_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`testproject_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/codetrackers
(
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `type` int(10) default 0,
  `cfg` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/codetrackers_uidx1 (`name`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testproject_codetracker
(
  `testproject_id` int(10) unsigned NOT NULL,
  `codetracker_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`testproject_id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/reqmgrsystems
(
  `id` int(10) unsigned NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `type` int(10) default 0,
  `cfg` text,
  PRIMARY KEY  (`id`),
  UNIQUE KEY /*prefix*/reqmgrsystems_uidx1 (`name`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testproject_reqmgrsystem
(
  `testproject_id` int(10) unsigned NOT NULL,
  `reqmgrsystem_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`testproject_id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/text_templates (
  id int(10) unsigned NOT NULL,
  type smallint(5) unsigned NOT NULL,
  title varchar(100) NOT NULL,
  template_data text,
  author_id int(10) unsigned default NULL,
  creation_ts TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  is_public tinyint(1) NOT NULL default '0',
  UNIQUE KEY idx_text_templates (type,title)
) DEFAULT CHARSET=utf8 COMMENT='Global Project Templates';



CREATE TABLE /*prefix*/testcase_relations (
  `id` int(10) unsigned NOT NULL auto_increment,
  `source_id` int(10) unsigned NOT NULL,
  `destination_id` int(10) unsigned NOT NULL,
  `link_status` tinyint(1) NOT NULL default '1',
  `relation_type` smallint(5) unsigned NOT NULL default '1',
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/req_monitor (
  `req_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `testproject_id` int(11) NOT NULL,
  PRIMARY KEY (`req_id`,`user_id`,`testproject_id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/plugins (
   `id` int(11) NOT NULL auto_increment,
   `basename`  varchar(100) NOT NULL,
   `enabled` tinyint(1) NOT NULL default '0',
   `author_id` int(10) unsigned default NULL,
   `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
   PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;

CREATE TABLE /*prefix*/plugins_configuration (
  `id` int(11) NOT NULL auto_increment,
  `testproject_id` int(11) NOT NULL,
  `config_key` varchar(255) NOT NULL,
  `config_type` int(11) NOT NULL,
  `config_value` varchar(255) NOT NULL,
  `author_id` int(10) unsigned default NULL,
  `creation_ts` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/testcase_platforms (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  testcase_id int(10) unsigned NOT NULL DEFAULT '0',
  tcversion_id int(10) unsigned NOT NULL DEFAULT '0',
  platform_id int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (id),
  UNIQUE KEY idx01_testcase_platform (testcase_id,tcversion_id,platform_id),
  KEY idx02_testcase_platform (tcversion_id)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/baseline_l1l2_context (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  testplan_id int(10) unsigned NOT NULL DEFAULT '0',
  platform_id int(10) unsigned NOT NULL DEFAULT '0',
  begin_exec_ts timestamp NOT NULL,
  end_exec_ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  creation_ts timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  UNIQUE KEY udx1_context (testplan_id,platform_id,creation_ts)
) DEFAULT CHARSET=utf8;


CREATE TABLE /*prefix*/baseline_l1l2_details (
  id int(10) unsigned NOT NULL AUTO_INCREMENT,
  context_id int(10) unsigned NOT NULL,
  top_tsuite_id int(10) unsigned NOT NULL DEFAULT '0',
  child_tsuite_id int(10) unsigned NOT NULL DEFAULT '0',
  status char(1) DEFAULT NULL,
  qty int(10) unsigned NOT NULL DEFAULT '0',
  total_tc int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY udx1_details (context_id,top_tsuite_id,child_tsuite_id,status)
) DEFAULT CHARSET=utf8;



# VIEWS
#
# @used_by latest_tcase_version_id
#
CREATE OR REPLACE VIEW /*prefix*/latest_tcase_version_number 
AS SELECT NH_TC.id AS testcase_id,max(TCV.version) AS version 
FROM /*prefix*/nodes_hierarchy NH_TC 
JOIN /*prefix*/nodes_hierarchy NH_TCV 
ON NH_TCV.parent_id = NH_TC.id
JOIN /*prefix*/tcversions TCV 
ON NH_TCV.id = TCV.id 
GROUP BY testcase_id;

#
# @uses latest_tcase_version_number
#
CREATE OR REPLACE VIEW /*prefix*/latest_tcase_version_id
AS SELECT
   LTCVN.testcase_id AS testcase_id,
   LTCVN.version AS version,
   TCV.id AS tcversion_id
FROM /*prefix*/latest_tcase_version_number LTCVN 
join /*prefix*/nodes_hierarchy NHTCV 
on NHTCV.parent_id = LTCVN.testcase_id 
join /*prefix*/tcversions TCV 
on TCV.id = NHTCV.id 
and TCV.version = LTCVN.version;


#
# @used_by latest_req_version_id
#
CREATE OR REPLACE VIEW /*prefix*/latest_req_version 
AS SELECT RQ.id AS req_id,max(RQV.version) AS version 
FROM /*prefix*/nodes_hierarchy NHRQV 
JOIN /*prefix*/requirements RQ 
ON RQ.id = NHRQV.parent_id 
JOIN /*prefix*/req_versions RQV 
ON RQV.id = NHRQV.id
GROUP BY RQ.id;

#
# @uses latest_req_version
#
CREATE OR REPLACE VIEW /*prefix*/latest_req_version_id
AS SELECT
   LRQVN.req_id AS req_id,
   LRQVN.version AS version,
   REQV.id AS req_version_id
FROM /*prefix*/latest_req_version LRQVN 
JOIN /*prefix*/nodes_hierarchy NHRQV
ON NHRQV.parent_id = LRQVN.req_id 
JOIN /*prefix*/req_versions REQV 
ON REQV.id = NHRQV.id AND REQV.version = LRQVN.version;

# 
CREATE OR REPLACE VIEW /*prefix*/latest_rspec_revision 
AS SELECT RSR.parent_id AS req_spec_id, RS.testproject_id AS testproject_id,
MAX(RSR.revision) AS revision 
FROM /*prefix*/req_specs_revisions RSR 
JOIN /*prefix*/req_specs RS 
ON RS.id = RSR.parent_id
GROUP BY RSR.parent_id,RS.testproject_id;

# 
CREATE OR REPLACE VIEW /*prefix*/tcversions_without_keywords
AS SELECT
   NHTCV.parent_id AS testcase_id,
   NHTCV.id AS id
FROM /*prefix*/nodes_hierarchy NHTCV 
WHERE NHTCV.node_type_id = 4 AND
NOT(EXISTS(SELECT 1 FROM /*prefix*/testcase_keywords TCK 
           WHERE TCK.tcversion_id = NHTCV.id));


# 
CREATE OR REPLACE VIEW /*prefix*/latest_exec_by_testplan 
AS SELECT tcversion_id, testplan_id, MAX(id) AS id 
FROM /*prefix*/executions 
GROUP BY tcversion_id,testplan_id;

#
CREATE OR REPLACE VIEW /*prefix*/latest_exec_by_context
AS SELECT tcversion_id, testplan_id,build_id,platform_id,max(id) AS id
FROM /*prefix*/executions 
GROUP BY tcversion_id,testplan_id,build_id,platform_id;

#
CREATE OR REPLACE VIEW /*prefix*/tcversions_without_platforms
AS SELECT
   NHTCV.parent_id AS testcase_id,
   NHTCV.id AS id
FROM /*prefix*/nodes_hierarchy NHTCV 
WHERE NHTCV.node_type_id = 4 AND
NOT(EXISTS(SELECT 1 FROM /*prefix*/testcase_platforms TCPL
           WHERE TCPL.tcversion_id = NHTCV.id));


#
CREATE OR REPLACE VIEW /*prefix*/latest_exec_by_testplan_plat
AS SELECT tcversion_id, testplan_id,platform_id,max(id) AS id
FROM /*prefix*/executions 
GROUP BY tcversion_id,testplan_id,platform_id;

#
CREATE OR REPLACE VIEW /*prefix*/tsuites_tree_depth_2
AS SELECT TPRJ.prefix,
NHTPRJ.name AS testproject_name,    
NHTS_L1.name AS level1_name,
NHTS_L2.name AS level2_name,
NHTPRJ.id AS testproject_id, 
NHTS_L1.id AS level1_id, 
NHTS_L2.id AS level2_id 
FROM /*prefix*/testprojects TPRJ 
JOIN /*prefix*/nodes_hierarchy NHTPRJ 
ON TPRJ.id = NHTPRJ.id
LEFT OUTER JOIN /*prefix*/nodes_hierarchy NHTS_L1 
ON NHTS_L1.parent_id = NHTPRJ.id
LEFT OUTER JOIN /*prefix*/nodes_hierarchy NHTS_L2
ON NHTS_L2.parent_id = NHTS_L1.id 
WHERE NHTPRJ.node_type_id = 1 
AND NHTS_L1.node_type_id = 2
AND NHTS_L2.node_type_id = 2;

#
CREATE OR REPLACE VIEW /*prefix*/exec_by_date_time 
AS (
SELECT NHTPL.name AS testplan_name, 
DATE_FORMAT(E.execution_ts, '%Y-%m-%d') AS yyyy_mm_dd,
DATE_FORMAT(E.execution_ts, '%Y-%m') AS yyyy_mm,
DATE_FORMAT(E.execution_ts, '%H') AS hh,
DATE_FORMAT(E.execution_ts, '%k') AS hour,
E.* FROM /*prefix*/executions E
JOIN /*prefix*/testplans TPL on TPL.id=E.testplan_id
JOIN /*prefix*/nodes_hierarchy NHTPL on NHTPL.id = TPL.id);

# TestLink Open Source Project - http://testlink.sourceforge.net/
# testlink_create_default_data.sql
# SQL script - create default data (rights & admin account)
#
# Database Type: MySQL
# ---------------------------------------------------------------------------------

# Database version
INSERT INTO /*prefix*/db_version (version,notes,upgrade_ts) VALUES('DB 1.9.20', 'TestLink 1.9.20 Raijin',CURRENT_TIMESTAMP());

# Node types -
INSERT INTO /*prefix*/node_types  (id,description) VALUES (1,'testproject');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (2,'testsuite');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (3,'testcase');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (4,'testcase_version');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (5,'testplan');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (6,'requirement_spec');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (7,'requirement');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (8,'requirement_version');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (9,'testcase_step');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (10,'requirement_revision');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (11,'requirement_spec_revision');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (12,'build');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (13,'platform');
INSERT INTO /*prefix*/node_types  (id,description) VALUES (14,'user');


# Roles -
INSERT INTO /*prefix*/roles  (id,description) VALUES (1, '<reserved system role 1>');
INSERT INTO /*prefix*/roles  (id,description) VALUES (2, '<reserved system role 2>');
INSERT INTO /*prefix*/roles  (id,description) VALUES (3, '<no rights>');
INSERT INTO /*prefix*/roles  (id,description) VALUES (4, 'test designer');
INSERT INTO /*prefix*/roles  (id,description) VALUES (5, 'guest');
INSERT INTO /*prefix*/roles  (id,description) VALUES (6, 'senior tester');
INSERT INTO /*prefix*/roles  (id,description) VALUES (7, 'tester');
INSERT INTO /*prefix*/roles  (id,description) VALUES (8, 'admin');
INSERT INTO /*prefix*/roles  (id,description) VALUES (9, 'leader');

# Rights - 
INSERT INTO /*prefix*/rights  (id,description) VALUES (1 ,'testplan_execute');
INSERT INTO /*prefix*/rights  (id,description) VALUES (2 ,'testplan_create_build');
INSERT INTO /*prefix*/rights  (id,description) VALUES (3 ,'testplan_metrics');
INSERT INTO /*prefix*/rights  (id,description) VALUES (4 ,'testplan_planning');
INSERT INTO /*prefix*/rights  (id,description) VALUES (5 ,'testplan_user_role_assignment');
INSERT INTO /*prefix*/rights  (id,description) VALUES (6 ,'mgt_view_tc');
INSERT INTO /*prefix*/rights  (id,description) VALUES (7 ,'mgt_modify_tc');
INSERT INTO /*prefix*/rights  (id,description) VALUES (8 ,'mgt_view_key');
INSERT INTO /*prefix*/rights  (id,description) VALUES (9 ,'mgt_modify_key');
INSERT INTO /*prefix*/rights  (id,description) VALUES (10,'mgt_view_req');
INSERT INTO /*prefix*/rights  (id,description) VALUES (11,'mgt_modify_req');
INSERT INTO /*prefix*/rights  (id,description) VALUES (12,'mgt_modify_product');
INSERT INTO /*prefix*/rights  (id,description) VALUES (13,'mgt_users');
INSERT INTO /*prefix*/rights  (id,description) VALUES (14,'role_management');
INSERT INTO /*prefix*/rights  (id,description) VALUES (15,'user_role_assignment');
INSERT INTO /*prefix*/rights  (id,description) VALUES (16,'mgt_testplan_create');
INSERT INTO /*prefix*/rights  (id,description) VALUES (17,'cfield_view');
INSERT INTO /*prefix*/rights  (id,description) VALUES (18,'cfield_management');
INSERT INTO /*prefix*/rights  (id,description) VALUES (19,'system_configuration');
INSERT INTO /*prefix*/rights  (id,description) VALUES (20,'mgt_view_events');
INSERT INTO /*prefix*/rights  (id,description) VALUES (21,'mgt_view_usergroups');
INSERT INTO /*prefix*/rights  (id,description) VALUES (22,'events_mgt');
INSERT INTO /*prefix*/rights  (id,description) VALUES (23,'testproject_user_role_assignment');
INSERT INTO /*prefix*/rights  (id,description) VALUES (24,'platform_management');
INSERT INTO /*prefix*/rights  (id,description) VALUES (25,'platform_view');
INSERT INTO /*prefix*/rights  (id,description) VALUES (26,'project_inventory_management');
INSERT INTO /*prefix*/rights  (id,description) VALUES (27,'project_inventory_view');
INSERT INTO /*prefix*/rights  (id,description) VALUES (28,'req_tcase_link_management');
INSERT INTO /*prefix*/rights  (id,description) VALUES (29,'keyword_assignment');
INSERT INTO /*prefix*/rights  (id,description) VALUES (30,'mgt_unfreeze_req');
INSERT INTO /*prefix*/rights  (id,description) VALUES (31,'issuetracker_management');
INSERT INTO /*prefix*/rights  (id,description) VALUES (32,'issuetracker_view');
INSERT INTO /*prefix*/rights  (id,description) VALUES (33,'reqmgrsystem_management');
INSERT INTO /*prefix*/rights  (id,description) VALUES (34,'reqmgrsystem_view');
INSERT INTO /*prefix*/rights  (id,description) VALUES (35,'exec_edit_notes');
INSERT INTO /*prefix*/rights  (id,description) VALUES (36,'exec_delete');
INSERT INTO /*prefix*/rights  (id,description) VALUES (37,'testplan_unlink_executed_testcases');
INSERT INTO /*prefix*/rights  (id,description) VALUES (38,'testproject_delete_executed_testcases');
INSERT INTO /*prefix*/rights  (id,description) VALUES (39,'testproject_edit_executed_testcases');

# since 1.9.10
INSERT INTO /*prefix*/rights  (id,description) VALUES (40,'testplan_milestone_overview');
INSERT INTO /*prefix*/rights  (id,description) VALUES (41,'exec_testcases_assigned_to_me');
INSERT INTO /*prefix*/rights  (id,description) VALUES (42,'testproject_metrics_dashboard');
INSERT INTO /*prefix*/rights  (id,description) VALUES (43,'testplan_add_remove_platforms');
INSERT INTO /*prefix*/rights  (id,description) VALUES (44,'testplan_update_linked_testcase_versions');
INSERT INTO /*prefix*/rights  (id,description) VALUES (45,'testplan_set_urgent_testcases');
INSERT INTO /*prefix*/rights  (id,description) VALUES (46,'testplan_show_testcases_newest_versions');
INSERT INTO /*prefix*/rights  (id,description) VALUES (47,'testcase_freeze');

# since 1.9.15
INSERT INTO /*prefix*/rights  (id,description) VALUES (48,'mgt_plugins');

-- since 1.9.17
INSERT INTO /*prefix*/rights (id,description) VALUES (49,'exec_ro_access');
INSERT INTO /*prefix*/rights (id,description) VALUES (50,'monitor_requirement');
INSERT INTO /*prefix*/rights (id,description) VALUES (51,'codetracker_management');
INSERT INTO /*prefix*/rights (id,description) VALUES (52,'codetracker_view');
INSERT INTO /*prefix*/rights (id,description) VALUES (53,'cfield_assignment');
INSERT INTO /*prefix*/rights (id,description) VALUES (54,'exec_assign_testcases');

-- since 1.9.20
INSERT INTO /*prefix*/rights (id,description) VALUES (55,'testproject_add_remove_keywords_executed_tcversions');
INSERT INTO /*prefix*/rights (id,description) VALUES (56,'delete_frozen_tcversion');

# Rights for Administrator role
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,1 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,2 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,3 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,4 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,5 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,6 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,7 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,8 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,9 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,10);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,11);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,12);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,13);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,14);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,15);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,16);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,17);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,18);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,19);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,20);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,21);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,22);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,23);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,24);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,25);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,26);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,27);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,28);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,29);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,30);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,31);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,32);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,33);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,34);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,35);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,36);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,37);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,38);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,39);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,40);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,41);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,42);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,43);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,44);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,45);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,46);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,47);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,48);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,50);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,51);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,52);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,53);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (8,54);

# Rights for guest role
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (5,3 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (5,6 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (5,8 );

# Rights for test designer role
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,3 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,6 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,7 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,8 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,9 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,10);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,11);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,28);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,29);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,30);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (4,50);

# Rights for tester role
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (7,1 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (7,3 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (7,6 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (7,8 );

# Rights for senior tester role
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,1 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,2 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,3 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,6 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,7 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,8 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,9 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,11);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,25);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,27);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,28);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,29);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,30);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (6,50);

# Rights for leader role
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,1 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,2 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,3 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,4 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,5 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,6 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,7 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,8 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,9 );
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,10);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,11);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,15);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,16);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,24);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,25);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,26);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,27);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,28);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,29);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,30);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,47);
INSERT INTO /*prefix*/role_rights (role_id,right_id) VALUES (9,50);

# admin account 
# SECURITY: change password after first login
#
# TICKET 4342: Security problem with multiple Testlink installations on the same server 
INSERT INTO /*prefix*/users (login,password,role_id,email,first,last,locale,active,cookie_string)
			VALUES ('admin',MD5('$TESTLINK_PASSWORD'), 8,'', 'Testlink','Administrator', 'en_GB',1,CONCAT(MD5(RAND()),MD5('$TESTLINK_PASSWORD')));


# Assignment types
INSERT INTO /*prefix*/assignment_types (id,fk_table,description) VALUES(1,'testplan_tcversions','testcase_execution');
INSERT INTO /*prefix*/assignment_types (id,fk_table,description) VALUES(2,'tcversions','testcase_review');

# Assignment status
INSERT INTO /*prefix*/assignment_status (id,description) VALUES(1,'open');
INSERT INTO /*prefix*/assignment_status (id,description) VALUES(2,'closed');
INSERT INTO /*prefix*/assignment_status (id,description) VALUES(3,'completed');
INSERT INTO /*prefix*/assignment_status (id,description) VALUES(4,'todo_urgent');
INSERT INTO /*prefix*/assignment_status (id,description) VALUES(5,'todo');
