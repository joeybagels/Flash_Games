package com.zerog.utils.net
{
    /**
    * URL
    */
    public class URL
    {
        private static const PATTERN:RegExp = /^([A-Za-z0-9_+.]{1,8}:\/\/)?([!-~]+@)?([^\/?#:]*)(:[0-9]*)?(\/[^?#]*)?(\?[^#]*)?(\#.*)?/i;
        private var _url:String;
        private var _scheme:String;
        private var _userinfo:String;
        private var _host:String;
        private var _port:String;
        private var _path:String;
        private var _query:String;
        private var _fragment:String;
        
        /**
         * Create new URL Object
         *
         * @param s The url
         */
        function URL(url:String):void
        {
            var result:Array = url.match(URL.PATTERN);
            _url = result[0];      // http://user:pass@example.com:80/foo/bar.php?var1=foo&var2=bar#abc
            _scheme = result[1];   // http://
            _userinfo = result[2]; // user:pass@
            _host = result[3];     // example.com
            _port = result[4];     // :80
            _path = result[5];     // /foo/bar.php
            _query = result[6];    // ?var1=foo&var2=bar
            _fragment = result[7]; // #abc
        }
        
        /**
         * Get the url
         */
        public function get url():String
        {
            return _url.length<=0?undefined:_url;
        }
        
        /**
         * Get the scheme
         */
        public function get scheme():String
        { 
            return _scheme.length<=0?undefined:_scheme.substring(0,_scheme.length-3);
        }
        
        /**
         * Get the userinfo
         * Returns an object containing the user and/or password
         */
        public function get userinfo():Object
        { 
            var ret = {user:undefined,pass:undefined};
            if(_userinfo){
                var arr:Array = _userinfo.substring(0,_userinfo.length-1).split(':');
                ret.user = arr[0]?arr[0]:ret.user;
                ret.pass = arr[1]?arr[1]:ret.pas;
            }
            return ret; 
        }
        
        /**
         * Get the host
         */
        public function get host():String
        {
            return _host.length<=0?undefined:_host;
        }
        
        /**
         * Get the port
         */
        public function get port():int
        {
            return _port.length<=0?undefined:int(_port.substring(1,_port.length));
        }
        
        /**
         * Get the path
         */
        public function get path():String
        {
            return _path.length<=0?undefined:_path;
        }
        
        /**
         * Get the query
         * Returns an object containing the raw and parsed query string
         */
        public function get query():Object
        {
            var ret = {raw:undefined,parsed:undefined};
            if(_query && _query.length>0){
                ret.raw = _query;
                var _parse:String = _query.substring(1,_query.length);
                var _intovars:Array = _parse.split("&");
                ret.parsed = _intovars.length>0?{}:undefined;
                for(var i:int=0; i<_intovars.length; i++){
                    var _kv:Array = _intovars[i].split("=");
                    ret.parsed[_kv[0]] = _kv[1];
                }
            }
            return ret; 
        }
        
        /**
         * Get the fragment
         */
        public function get fragment():String
        {
            return _fragment.length<=0?undefined:_fragment;
        }
        
    }
}
