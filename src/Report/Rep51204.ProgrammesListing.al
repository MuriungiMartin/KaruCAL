#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51204 "Programmes Listing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Programmes Listing.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_1410; 1410)
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
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programmes_ListingCaption;Programmes_ListingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
                RequestFilterFields = "Code";
                column(ReportForNavId_3691; 3691)
                {
                }
                column(Programme_Stages_Code;Code)
                {
                }
                column(Programme_Stages_Description;Description)
                {
                }
                column(Programme_Stages_Programme_Code;"Programme Code")
                {
                }
                dataitem(UnknownTable61517;UnknownTable61517)
                {
                    DataItemLink = "Programme Code"=field("Programme Code"),"Stage Code"=field(Code);
                    column(ReportForNavId_2955; 2955)
                    {
                    }
                    column(Units_Subjects_Code;Code)
                    {
                    }
                    column(Units_Subjects_Desription;Desription)
                    {
                    }
                    column(Units_Subjects__Unit_Type_;"Unit Type")
                    {
                    }
                    column(Units_Subjects_DesriptionCaption;FieldCaption(Desription))
                    {
                    }
                    column(Units_Subjects_CodeCaption;FieldCaption(Code))
                    {
                    }
                    column(Units_Subjects__Unit_Type_Caption;FieldCaption("Unit Type"))
                    {
                    }
                    column(Units_Subjects_Programme_Code;"Programme Code")
                    {
                    }
                    column(Units_Subjects_Stage_Code;"Stage Code")
                    {
                    }
                    column(Units_Subjects_Entry_No;"Entry No")
                    {
                    }
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
        Programmes_ListingCaptionLbl: label 'Programmes Listing';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

