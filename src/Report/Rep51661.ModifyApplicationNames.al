#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51661 "Modify Application Names"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Modify Application Names.rdlc';

    dataset
    {
        dataitem(UnknownTable61348;UnknownTable61348)
        {
            RequestFilterFields = "Enquiry No.";
            column(ReportForNavId_8879; 8879)
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
            column(Enquiry_Header__Name_Surname_First__;"Name(Surname First)")
            {
            }
            column(Enquiry_Header_Surname;Surname)
            {
            }
            column(Enquiry_Header__Other_Names_;"Other Names")
            {
            }
            column(KSPS_Enquiry_HeaderCaption;KSPS_Enquiry_HeaderCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Enquiry_Header__Name_Surname_First__Caption;FieldCaption("Name(Surname First)"))
            {
            }
            column(Enquiry_Header_SurnameCaption;FieldCaption(Surname))
            {
            }
            column(Enquiry_Header__Other_Names_Caption;FieldCaption("Other Names"))
            {
            }
            column(Enquiry_Header_Enquiry_No_;"Enquiry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ("Name(Surname First)"<>'')  or (StrLen("Name(Surname First)")>10) then begin
                Surname:=CopyStr("ACA-Enquiry Header"."Name(Surname First)",1,StrPos("Name(Surname First)",' ')-1);
                lStart:=StrPos("Name(Surname First)",' ');
                lStart:=lStart + 1;
                lEnd:=StrLen("Name(Surname First)")-lStart;
                "Other Names":=CopyStr("Name(Surname First)",lStart,lEnd + 1);
                Modify;
                end;
            end;
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
        lStart: Integer;
        lEnd: Integer;
        KSPS_Enquiry_HeaderCaptionLbl: label 'KSPS Enquiry Header';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

