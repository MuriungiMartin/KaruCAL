#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51238 "Daily Menu"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Daily Menu.rdlc';

    dataset
    {
        dataitem(UnknownTable61169;UnknownTable61169)
        {
            RequestFilterFields = "Menu Date",Menu;
            column(ReportForNavId_2461; 2461)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Daily_Menu__Menu_Date_;"Menu Date")
            {
            }
            column(Daily_Menu_Menu;Menu)
            {
            }
            column(Daily_Menu_Description;Description)
            {
            }
            column(Daily_Menu__Unit_Cost_;"Unit Cost")
            {
            }
            column(Daily_Menu__produced_By_;"produced By")
            {
            }
            column(Daily_MenuCaption;Daily_MenuCaptionLbl)
            {
            }
            column(Daily_Menu__Menu_Date_Caption;FieldCaption("Menu Date"))
            {
            }
            column(Daily_Menu_MenuCaption;FieldCaption(Menu))
            {
            }
            column(Daily_Menu_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Daily_Menu__Unit_Cost_Caption;FieldCaption("Unit Cost"))
            {
            }
            column(Prepared_ByCaption;Prepared_ByCaptionLbl)
            {
            }
            column(Daily_Menu_Entry_No;"Entry No")
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Daily_MenuCaptionLbl: label 'Daily Menu';
        Prepared_ByCaptionLbl: label 'Prepared By';
}

