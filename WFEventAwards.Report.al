#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51414 "WF Event Awards"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Event Awards.rdlc';

    dataset
    {
        dataitem(UnknownTable61455;UnknownTable61455)
        {
            DataItemTableView = sorting("Line No.",Type,"Type No.",Event,"Student No.");
            RequestFilterFields = "Line No.",Type,"Type No.","Event";
            column(ReportForNavId_1969; 1969)
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
            column(WF_Award_Header__Event_;"Event")
            {
            }
            column(WF_Award_Header__Event_name_;"Event name")
            {
            }
            column(WF_Award_Header__Type_No__;"Type No.")
            {
            }
            column(WF_Award_Header_Type;Type)
            {
            }
            column(WF_Award_Header__Student_No__;"Student No.")
            {
            }
            column(WF_Award_Header__Student_Name_;"Student Name")
            {
            }
            column(WF_Award_Header__Award_Name_;"Award Name")
            {
            }
            column(WF_Award_Header_Position;Position)
            {
            }
            column(WF_Award_Header_Individual;Individual)
            {
            }
            column(WF_Award_Header_Remarks;Remarks)
            {
            }
            column(Awards__Club_Society_Sports_Caption;Awards__Club_Society_Sports_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(WF_Award_Header__Event_Caption;FieldCaption("Event"))
            {
            }
            column(WF_Award_Header__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(WF_Award_Header__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(WF_Award_Header__Award_Name_Caption;FieldCaption("Award Name"))
            {
            }
            column(WF_Award_Header_PositionCaption;FieldCaption(Position))
            {
            }
            column(WF_Award_Header_IndividualCaption;FieldCaption(Individual))
            {
            }
            column(WF_Award_Header_RemarksCaption;FieldCaption(Remarks))
            {
            }
            column(WF_Award_Header__Type_No__Caption;FieldCaption("Type No."))
            {
            }
            column(WF_Award_Header_TypeCaption;FieldCaption(Type))
            {
            }
            column(WF_Award_Header_Line_No_;"Line No.")
            {
            }

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
        Awards__Club_Society_Sports_CaptionLbl: label 'Awards (Club/Society/Sports)';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

