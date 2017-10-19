using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class Reportes : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            Class_DB db = new Class_DB();
            dt = db.GetTableFromSQL("select top 1 * from Restaurant where id_plato = " + ArgId);
        }
    }
}