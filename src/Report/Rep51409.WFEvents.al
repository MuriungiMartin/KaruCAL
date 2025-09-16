#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51409 "WF Events"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Events.rdlc';

    dataset
    {
        dataitem(UnknownTable61450;UnknownTable61450)
        {
            DataItemTableView = sorting(Type,Code);
            RequestFilterFields = Type;
            column(ReportForNavId_6457; 6457)
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
            column(WF_Event_Type;Type)
            {
            }
            column(WF_Event_Code;Code)
            {
            }
            column(WF_Event_Description;Description)
            {
            }
            column(Event_ListCaption;Event_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(WF_Event_CodeCaption;FieldCaption(Code))
            {
            }
            column(WF_Event_DescriptionCaption;FieldCaption(Description))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Type);
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Event_ListCaptionLbl: label 'Event List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TypeCaptionLbl: label 'Type';
}

