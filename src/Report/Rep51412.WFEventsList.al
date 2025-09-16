#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51412 "WF Events List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Events List.rdlc';

    dataset
    {
        dataitem(UnknownTable61453;UnknownTable61453)
        {
            DataItemTableView = sorting("Line No.",Type,"Type No.",Event);
            RequestFilterFields = "Line No.",Type,"Type No.";
            column(ReportForNavId_3028; 3028)
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
            column(WF_Event_Calendar_Type;Type)
            {
            }
            column(WF_Event_Calendar__Type_Name_;"Type Name")
            {
            }
            column(WF_Event_Calendar__Event_Name_;"Event Name")
            {
            }
            column(WF_Event_Calendar_Date;Date)
            {
            }
            column(WF_Event_Calendar_Time;Time)
            {
            }
            column(WF_Event_Calendar_Confirmed;Confirmed)
            {
            }
            column(WF_Event_Calendar_Occured;Occured)
            {
            }
            column(Events_ListCaption;Events_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(Club_Sport_SocietyCaption;Club_Sport_SocietyCaptionLbl)
            {
            }
            column(EventCaption;EventCaptionLbl)
            {
            }
            column(WF_Event_Calendar_DateCaption;FieldCaption(Date))
            {
            }
            column(WF_Event_Calendar_TimeCaption;FieldCaption(Time))
            {
            }
            column(WF_Event_Calendar_ConfirmedCaption;FieldCaption(Confirmed))
            {
            }
            column(WF_Event_Calendar_OccuredCaption;FieldCaption(Occured))
            {
            }
            column(WF_Event_Calendar_Line_No_;"Line No.")
            {
            }
            column(WF_Event_Calendar_Type_No_;"Type No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Type No.");
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
        Events_ListCaptionLbl: label 'Events List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TypeCaptionLbl: label 'Type';
        Club_Sport_SocietyCaptionLbl: label 'Club/Sport/Society';
        EventCaptionLbl: label 'Event';
}

