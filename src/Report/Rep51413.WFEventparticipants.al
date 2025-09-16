#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51413 "WF Event participants"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Event participants.rdlc';

    dataset
    {
        dataitem(UnknownTable61454;UnknownTable61454)
        {
            DataItemTableView = sorting("Line No.",Type,"Type No.",Event);
            RequestFilterFields = "Line No.",Type,"Type No.","Event";
            column(ReportForNavId_8815; 8815)
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
            column(Event_________Event_Name_;"Event" +' ' +"Event Name")
            {
            }
            column(WF_Event_Participants__Type_No__;"Type No.")
            {
            }
            column(WF_Event_Participants_Type;Type)
            {
            }
            column(WF_Event_Participants__Student_No__;"Student No.")
            {
            }
            column(WF_Event_Participants__Student_Name_;"Student Name")
            {
            }
            column(WF_Event_Participants_Confirmed;Confirmed)
            {
            }
            column(WF_Event_Participants_Remarks;Remarks)
            {
            }
            column(Event_ParticipantsCaption;Event_ParticipantsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(EventCaption;EventCaptionLbl)
            {
            }
            column(WF_Event_Participants__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(WF_Event_Participants__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(WF_Event_Participants_ConfirmedCaption;FieldCaption(Confirmed))
            {
            }
            column(WF_Event_Participants_RemarksCaption;FieldCaption(Remarks))
            {
            }
            column(WF_Event_Participants__Type_No__Caption;FieldCaption("Type No."))
            {
            }
            column(WF_Event_Participants_TypeCaption;FieldCaption(Type))
            {
            }
            column(WF_Event_Participants_Line_No_;"Line No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Event Name");
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Event");
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
        Event_ParticipantsCaptionLbl: label 'Event Participants';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        EventCaptionLbl: label 'Event';
}

