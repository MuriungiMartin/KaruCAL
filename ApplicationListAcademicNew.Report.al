#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51352 "Application List Academic New"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Application List Academic New.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            RequestFilterFields = "Application No.";
            column(ReportForNavId_2953; 2953)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(compName;info.Name)
            {
            }
            column(address;info.Address)
            {
            }
            column(phoneno;info."Phone No.")
            {
            }
            column(email;info."E-Mail")
            {
            }
            column(website;info."Home Page")
            {
            }
            column(pic;info.Picture)
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
            column(Application_Form_Header__Application_No__;"Application No.")
            {
            }
            column(Application_Form_Header__Application_Date_;"Application Date")
            {
            }
            column(Surname_________Other_Names_;Surname + ' ' +"Other Names")
            {
            }
            column(Application_Form_Header__Date_Of_Birth_;"Date Of Birth")
            {
            }
            column(Application_Form_Header_Gender;Gender)
            {
            }
            column(Application_Form_Header__Marital_Status_;"Marital Status")
            {
            }
            column(DegreeName;DegreeName)
            {
            }
            column(Application_Form_Header__Mean_Grade_Acquired_;"Mean Grade Acquired")
            {
            }
            column(Application_Form_Header_Status;Status)
            {
            }
            column(IntC;IntC)
            {
            }
            column(Applications_ListingCaption;Applications_ListingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No_Caption;No_CaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Applicant_NamesCaption;Applicant_NamesCaptionLbl)
            {
            }
            column(Application_Form_Header__Date_Of_Birth_Caption;FieldCaption("Date Of Birth"))
            {
            }
            column(Application_Form_Header_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Application_Form_Header__Marital_Status_Caption;FieldCaption("Marital Status"))
            {
            }
            column(Degree_Applied_ForCaption;Degree_Applied_ForCaptionLbl)
            {
            }
            column(GradeCaption;GradeCaptionLbl)
            {
            }
            column(Application_Form_Header_StatusCaption;FieldCaption(Status))
            {
            }
            column(TOTALCaption;TOTALCaptionLbl)
            {
            }
            column(status;"ACA-Applic. Form Header".Status)
            {
            }
            column(Admitteddegree;"ACA-Applic. Form Header"."Admitted Degree")
            {
            }
            column(Intakecode;"ACA-Applic. Form Header"."Intake Code")
            {
            }
            column(Modeofstudy;"ACA-Applic. Form Header"."Mode of Study")
            {
            }

            trigger OnAfterGetRecord()
            begin
                /*Get the name of the programme from the database*/
                Programme.Reset;
                DegreeName:='';
                if Programme.Get("First Degree Choice") then
                  begin
                    DegreeName:=Programme.Description;
                  end;
                
                /*Add the total count*/
                IntC:=IntC + 1;

            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Application No.");
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

    trigger OnInitReport()
    begin
        if info.Get() then begin
          info.CalcFields(info.Picture);
          end;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        DegreeName: Text[200];
        Programme: Record UnknownRecord61511;
        IntC: Integer;
        Applications_ListingCaptionLbl: label 'Applications Listing';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No_CaptionLbl: label 'No.';
        DateCaptionLbl: label 'Date';
        Applicant_NamesCaptionLbl: label 'Applicant Names';
        Degree_Applied_ForCaptionLbl: label 'Degree Applied For';
        GradeCaptionLbl: label 'Grade';
        TOTALCaptionLbl: label 'TOTAL';
        info: Record "Company Information";
}

