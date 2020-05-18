using System;
using System.Xml;
using System.Xml.Serialization;

namespace PsIntacct
{
    [XmlRoot("DISPLAYCONTACT")]
    public class Contact
    {
        [XmlElement("CONTACTNAME")]
        public string Name { get; set; }

        [XmlElement("PREFIX")]
        public string Prefox { get; set; }

        [XmlElement("FIRSTNAME")]
        public string FirsName { get; set; }

        [XmlElement("LASTNAME")]
        public string LastName { get; set; }

        [XmlElement("INITIAL")]
        public string Initial { get; set; }

        [XmlElement("PRINTAS")]
        public string PrintAs { get; set; }

        [XmlElement("COMPANYNAME")]
        public string CompanyName { get; set; }
        
        [XmlElement("TAXABLE")]
        public bool Taxable { get; set; }

        [XmlElement("TAXGROUP")]
        public string TaxGrouip { get; set; }

        [XmlElement("PHONE1")]
        public string Phone1 { get; set; }

        [XmlElement("PHONE2")]
        public string Phone2 { get; set; }

        [XmlElement("CELLPHONE")]
        public string Cellphone { get; set; }

        [XmlElement("PAGER")]
        public string Pager { get; set; }

        [XmlElement("FAX")]
        public string Fax { get; set; }

        [XmlElement("EMAIL1")]
        public string Email1 { get; set; }

        [XmlElement("EMAIL2")]
        public string Email2 { get; set; }

        [XmlElement("URL1")]
        public string Url1 { get; set; }

        [XmlElement("URL2")]
        public string Url2 { get; set; }

        [XmlElement("MAILADDRESS")]
        public Address MailingAddress { get; set; }
    }
}
