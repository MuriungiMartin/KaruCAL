#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51593 "Summary Course Registrations"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Summary Course Registrations.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = Category,Faculty,"Code","Stage Filter","Semester Filter","No. Of Units Filter";
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
            column(Programme_Category;Category)
            {
            }
            column(StudCount;StudCount)
            {
            }
            column(Programme_Registered;Registered)
            {
            }
            column(Total1;Total1)
            {
            }
            column(Total2;Total2)
            {
            }
            column(PercentComplete;PercentComplete)
            {
            }
            column(Summary_Course_RegistrationCaption;Summary_Course_RegistrationCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme_CategoryCaption;FieldCaption(Category))
            {
            }
            column(No__Of_StudentsCaption;No__Of_StudentsCaptionLbl)
            {
            }
            column(Programme_RegisteredCaption;FieldCaption(Registered))
            {
            }
            column(Percentage_CompleteCaption;Percentage_CompleteCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                StudCount:=0;

                CReg.Reset;
                CReg.SetRange(CReg.Programme,"ACA-Programme".Code);
                CReg.SetFilter(CReg.Stage,"ACA-Programme".GetFilter("ACA-Programme"."Stage Filter"));
                CReg.SetFilter(CReg.Semester,"ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                CReg.SetFilter(CReg."Units Taken","ACA-Programme".GetFilter("ACA-Programme"."No. Of Units Filter"));
                if CReg.Find('-') then
                StudCount:=CReg.Count;

                "ACA-Programme".CalcFields("ACA-Programme".Registered);
                Total1:=Total1+"ACA-Programme".Registered;
                Total2:=Total2+StudCount;
                if Total1>0 then PercentComplete:=Total2/Total1*100;
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
        CReg: Record UnknownRecord61532;
        StudCount: Integer;
        Total1: Integer;
        Total2: Integer;
        PercentComplete: Decimal;
        Summary_Course_RegistrationCaptionLbl: label 'Summary Course Registration';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No__Of_StudentsCaptionLbl: label 'No. Of Students';
        Percentage_CompleteCaptionLbl: label 'Percentage Complete';
        EmptyStringCaptionLbl: label '%';
}

