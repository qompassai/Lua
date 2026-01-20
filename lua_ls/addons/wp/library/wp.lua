-- wp.lua
-- Qompass AI - [ ]
-- Copyright (C) 2026 Qompass AI, All rights reserved
-- ----------------------------------------
---@meta
---@class WPProperties : table<string, any>
---@class WPObject
---@field properties WPProperties
---@class WPNode : WPObject
---@field set_param      fun(self: WPNode, id: string, pod: any)
---@field iterate_params fun(self: WPNode, id: string): fun(): any
---@class WPSessionItem : WPObject
---@field id integer
---@field get_associated_proxy fun(self: WPSessionItem, role: string): WPNode
---@field get_ports_format fun(self: WPSessionItem): any, any
---@field set_ports_format fun(self: WPSessionItem, f: any, m: any, cb: fun(item: WPSessionItem, e: any))
---@field remove fun(self: WPSessionItem)
---@field register fun(self: WPSessionItem)
---@class WPEvent
---@field get_subject     fun(self: WPEvent): WPObject
---@field get_source      fun(self: WPEvent): WPObject
---@field get_properties  fun(self: WPEvent): table<string, any>
---@field set_data        fun(self: WPEvent, key: string, value: any)

---@class Settings
Settings = {}

---@param key string
---@return boolean
function Settings.get_boolean(key) end

---@class LogTopic
local LogTopic = {}
function LogTopic:info(...) end

function LogTopic:warning(...) end

function LogTopic:debug(...) end

---@class LogClass
Log = {}
---@param name string
---@return LogTopic
function Log.open_topic(name) end

---@class SimpleEventHookClass
---@param opts table<string, any>
---@return SimpleEventHookClass
function SimpleEventHook(opts) end

---@class AsyncEventHookClass
---@param opts table<string, any>
---@return AsyncEventHookClass
function AsyncEventHook(opts) end
