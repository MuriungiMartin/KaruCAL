#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51287 "HTL Food Recepie"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HTL Food Recepie.rdlc';

    dataset
    {
        dataitem(UnknownTable61167;UnknownTable61167)
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            column(ReportForNavId_6292; 6292)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Food_Menu_Code;Code)
            {
            }
            column(Food_Menu_Description;Description)
            {
            }
            column(Food_Menu__Unit_Cost_;"Unit Cost")
            {
            }
            column(Food_Menu__Units_Of_Measure_;"Units Of Measure")
            {
            }
            column(Food_Menu_Quantity;Quantity)
            {
            }
            column(Food_Recepie_ReportCaption;Food_Recepie_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Food_Menu_CodeCaption;FieldCaption(Code))
            {
            }
            column(Food_Menu_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Food_Menu__Unit_Cost_Caption;FieldCaption("Unit Cost"))
            {
            }
            column(Food_Menu__Units_Of_Measure_Caption;FieldCaption("Units Of Measure"))
            {
            }
            column(Food_Menu_QuantityCaption;FieldCaption(Quantity))
            {
            }
            dataitem(UnknownTable61168;UnknownTable61168)
            {
                DataItemLink = Menu=field(Code);
                column(ReportForNavId_5504; 5504)
                {
                }
                column(Food_Menu_Line__Item_No_;"Item No")
                {
                }
                column(Food_Menu_Line_Description;Description)
                {
                }
                column(Food_Menu_Line_Units;Units)
                {
                }
                column(Food_Menu_Line_Quantity;Quantity)
                {
                }
                column(Food_Menu_Line__Unit_Cost_;"Unit Cost")
                {
                }
                column(Food_Menu_Line__Total_Cost_;"Total Cost")
                {
                }
                column(Food_Menu_Line__Total_Cost__Control1000000030;"Total Cost")
                {
                }
                column(Food_Menu_Line__Item_No_Caption;FieldCaption("Item No"))
                {
                }
                column(Food_Menu_Line_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Food_Menu_Line_UnitsCaption;FieldCaption(Units))
                {
                }
                column(Food_Menu_Line_QuantityCaption;FieldCaption(Quantity))
                {
                }
                column(Food_Menu_Line__Unit_Cost_Caption;FieldCaption("Unit Cost"))
                {
                }
                column(Food_Menu_Line__Total_Cost_Caption;FieldCaption("Total Cost"))
                {
                }
                column(Food_Menu_Line__Total_Cost__Control1000000030Caption;FieldCaption("Total Cost"))
                {
                }
                column(Food_Menu_Line_Menu;Menu)
                {
                }
                column(Food_Menu_Line_Line_No;"Line No")
                {
                }
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
        Food_Recepie_ReportCaptionLbl: label 'Food Recepie Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

