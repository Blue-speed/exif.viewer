using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using System.IO;
using Microsoft.AspNetCore.Http;
using exif.viewer.Models;
using System.Diagnostics;

namespace exif.viewer.Controllers
{
    public class HomeController : Controller
    {
        // GET api/values
        public IActionResult  Index()
        {
            return View("Index");
        }

        [HttpPost]
        public IActionResult Index(string query)
        {
            return View("SearchResults", System.Web.HttpUtility.UrlEncode(query));
        }

        public IActionResult Error()
        {
            return View(new ErrorModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
