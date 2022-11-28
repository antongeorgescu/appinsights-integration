using Microsoft.AspNetCore.Mvc.ModelBinding;
using System;
using System.Drawing;
using System.Security;
using AngularSpaWebApi.Controllers;
using AngularSpaWebApi.Services;
using ArchitectWorksPortal.Repositories;
using ArchitectWorksPortal.Models;

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
        private IDatasetRepository _datasetRepo;

        public ThrowErrorRequest(IDatasetRepository? repository = null)
        {
            _datasetRepo = repository;
        }

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

        public ThrowErrorRequest Generate(int wordcount = 0)
        {
            Random res = new Random();
                        
            _message = ExceptionServices.GenerateRandomLoremIpsumMessage();
            var statusList = ExceptionUtilitiesController.HttpResponseStatusList;
            _status = statusList[res.Next(0, statusList.Count-1)];
            _serialized = $"CLASS:{_class}|DESCRIPTION:{_description}|MESSAGE:{_message}|STATUS:{_status}";
            return this;
        }

        public async Task<ThrowErrorRequest> GenerateDb(int wordcount = 0)
        {
            Random res = new Random();

            var exserv = new ExceptionServices(_datasetRepo);
            
            _message = await exserv.GenerateRandomLoremIpsumMessageDb();
            var statusList = ExceptionUtilitiesController.HttpResponseStatusList;
            _status = statusList[res.Next(0, statusList.Count - 1)];
            _serialized = $"CLASS:{_class}|DESCRIPTION:{_description}|MESSAGE:{_message}|STATUS:{_status}";
            return this;
        }
    }
}
