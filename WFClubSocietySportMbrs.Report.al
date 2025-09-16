#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51415 "WF Club Society Sport Mbrs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/WF Club Society Sport Mbrs.rdlc';

    dataset
    {
        dataitem(UnknownTable61448;UnknownTable61448)
        {
            DataItemTableView = sorting(Type,Code);
            RequestFilterFields = Type,"Code";
            column(ReportForNavId_9499; 9499)
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
            column(WF_Club_Society_Sport_Type;Type)
            {
            }
            column(WF_Club_Society_Sport_Code;Code)
            {
            }
            column(WF_Club_Society_Sport_Description;Description)
            {
            }
            column(WF_Club_Society_SportCaption;WF_Club_Society_SportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CodeCaption;CodeCaptionLbl)
            {
            }
            column(WF_Club_Society_Sport_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(DesignationCaption;DesignationCaptionLbl)
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
            {
            }
            column(Description_NameCaption;Description_NameCaptionLbl)
            {
            }
            dataitem(UnknownTable61452;UnknownTable61452)
            {
                DataItemLink = Type=field(Type),"Type No."=field(Code);
                column(ReportForNavId_5024; 5024)
                {
                }
                column(WF_Student_Member_Of__Designation_Name_;"Designation Name")
                {
                }
                column(WF_Student_Member_Of__Student_No__;"Student No.")
                {
                }
                column(WF_Student_Member_Of__Student_Name_;"Student Name")
                {
                }
                column(WF_Student_Member_Of_Line_No_;"Line No.")
                {
                }
                column(WF_Student_Member_Of_Type;Type)
                {
                }
                column(WF_Student_Member_Of_Type_No_;"Type No.")
                {
                }
                column(WF_Student_Member_Of_Active;Active)
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        WF_Club_Society_SportCaptionLbl: label 'WF Club/Society/Sport';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CodeCaptionLbl: label 'Code';
        DesignationCaptionLbl: label 'Designation';
        Student_No_CaptionLbl: label 'Student No.';
        Description_NameCaptionLbl: label 'Description/Name';
}

