#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51071 "Imprests Surrendered"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprests Surrendered.rdlc';

    dataset
    {
        dataitem(UnknownTable61625;UnknownTable61625)
        {
            RequestFilterFields = "PF No","Imprest No.","Date Surrendered";
            column(ReportForNavId_3957; 3957)
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
            column(Surrender_Lines__Imprest_No__;"Imprest No.")
            {
            }
            column(Surrender_Lines__PV_No_;"PV No")
            {
            }
            column(Surrender_Lines__PF_No_;"PF No")
            {
            }
            column(Surrender_Lines_Name;Name)
            {
            }
            column(Surrender_Lines__Imprest_Amount_;"Imprest Amount")
            {
            }
            column(Surrender_Lines__Surrendered_Amount_;"Surrendered Amount")
            {
            }
            column(Surrender_Lines__Date_Surrendered_;"Date Surrendered")
            {
            }
            column(Surrender_Lines__Time_Posted_;"Time Posted")
            {
            }
            column(Surrender_Lines__Posted_by_;"Posted by")
            {
            }
            column(Surrender_Lines__Type_of_Surrender_;"Type of Surrender")
            {
            }
            column(Surrender_LinesCaption;Surrender_LinesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Surrender_Lines__Imprest_No__Caption;FieldCaption("Imprest No."))
            {
            }
            column(Surrender_Lines__PV_No_Caption;FieldCaption("PV No"))
            {
            }
            column(Surrender_Lines__PF_No_Caption;FieldCaption("PF No"))
            {
            }
            column(Surrender_Lines_NameCaption;FieldCaption(Name))
            {
            }
            column(Surrender_Lines__Imprest_Amount_Caption;FieldCaption("Imprest Amount"))
            {
            }
            column(Surrender_Lines__Surrendered_Amount_Caption;FieldCaption("Surrendered Amount"))
            {
            }
            column(Surrender_Lines__Date_Surrendered_Caption;FieldCaption("Date Surrendered"))
            {
            }
            column(Surrender_Lines__Time_Posted_Caption;FieldCaption("Time Posted"))
            {
            }
            column(Surrender_Lines__Posted_by_Caption;FieldCaption("Posted by"))
            {
            }
            column(Surrender_Lines__Type_of_Surrender_Caption;FieldCaption("Type of Surrender"))
            {
            }
            column(Surrender_Lines_Line_No_;"Line No.")
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
        Surrender_LinesCaptionLbl: label 'Surrender Lines';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

