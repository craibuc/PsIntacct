using System;
using System.Xml;
using System.Xml.Serialization;

namespace PsIntacct
{
    [XmlRoot("MAILADDRESS")]
    public class Address
    {
        public Address()
        {
            CountryCode = "US";
        }

        [XmlElement("ADDRESS1")]
        public string Address1 { get; set; }

        [XmlElement("ADDRESS2")]
        public string Address2 { get; set; }

        [XmlElement("CITY")]
        public string City { get;set; }

        [XmlElement("STATE")]
        public string RegionCode { get;set; }

        [XmlElement("ZIP")]
        public string PostalCode { get;set; }

        [XmlElement("COUNTRYCODE")]
        public string CountryCode { get;set; }
    }

}