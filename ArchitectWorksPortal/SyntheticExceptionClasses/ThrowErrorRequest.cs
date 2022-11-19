using Microsoft.AspNetCore.Mvc.ModelBinding;
using System;
using System.Drawing;
using System.Security;
using AngularSpaWebApi.Controllers;
using AngularSpaWebApi.Services;

namespace AngularSpaWebApi.Logger
{
    public class ThrowErrorRequest
    {
        private string _code;
        private string _framework; 
        private string _class;
        private string _message;
        private string _description;
        private string _status;
        private dynamic _serialized = null;
        public string Code 
        {
            get { return _code; }
            set { _code = value; }
        }
        public string Framework
        {
            get { return _framework; }
            set { _framework = value; }
        }
        public string Serialized
        {
            get { return _serialized; }
            set { _serialized = value; }
        }
        public string Class
        {
            get { return _class; }
            set { _class = value; }
        }
        public string Description
        {
            get { return _description; }
            set { _description = value; }
        }
        public string Message
        {
            get { return _message; }
            set { _message = value; }
        }
        public string Status
        {
            get { return _status; }
            set { _status = value; }
        }

        public void Generate(int wordcount = 0)
        {
            Random res = new Random();
            if (wordcount == 0)
            {
                // generate a random # words between 5 and 15
                wordcount = res.Next(5, 15);
            }
            _message = string.Join(' ', ExceptionServices.GenerateSyntheticMessage(wordcount));
            var statusList = ExceptionUtilitiesController.HttpResponseStatusList;
            _status = statusList[res.Next(0, statusList.Count-1)];
            _serialized = $"CLASS:{_class}|DESCRIPTION:{_description}|MESSAGE:{_message}|STATUS:{_status}";
            return;
        }
    }
}
