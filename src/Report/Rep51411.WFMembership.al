#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51411 "WF Membership"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Membership.rdlc';

    dataset
    {
        dataitem(UnknownTable61452;UnknownTable61452)
        {
            DataItemTableView = sorting("Line No.",Type,"Type No.",Active);
            RequestFilterFields = "Line No.";
            column(ReportForNavId_5024; 5024)
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
            column(WF_Student_Member_Of_Type;Type)
            {
            }
            column(WF_Student_Member_Of__Type_No__;"Type No.")
            {
            }
            column(WF_Student_Member_Of__Student_No__;"Student No.")
            {
            }
            column(WF_Student_Member_Of__Student_Name_;"Student Name")
            {
            }
            column(WF_Student_Member_Of__Date_Expired_;"Date Expired")
            {
            }
            column(WF_Student_Member_Of_Active;Active)
            {
            }
            column(WF_Student_Member_Of__Date_Registered_;"Date Registered")
            {
            }
            column(WF_Student_Member_Of__Designation_Name_;"Designation Name")
            {
            }
            column(Number_of_Members_Listed_____FORMAT__WF_Student_Member_Of__COUNT_;'Number of Members Listed:' + Format("SWF-Student Member Of".Count))
            {
            }
            column(Membership_ListCaption;Membership_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(WF_Student_Member_Of_TypeCaption;FieldCaption(Type))
            {
            }
            column(WF_Student_Member_Of__Type_No__Caption;FieldCaption("Type No."))
            {
            }
            column(WF_Student_Member_Of__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(WF_Student_Member_Of__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(WF_Student_Member_Of__Date_Expired_Caption;FieldCaption("Date Expired"))
            {
            }
            column(WF_Student_Member_Of_ActiveCaption;FieldCaption(Active))
            {
            }
            column(WF_Student_Member_Of__Date_Registered_Caption;FieldCaption("Date Registered"))
            {
            }
            column(DesignationCaption;DesignationCaptionLbl)
            {
            }
            column(WF_Student_Member_Of_Line_No_;"Line No.")
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Line No.");
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
        Membership_ListCaptionLbl: label 'Membership List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DesignationCaptionLbl: label 'Designation';
}

