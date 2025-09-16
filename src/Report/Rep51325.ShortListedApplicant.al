#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51325 "Short Listed Applicant"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Short Listed Applicant.rdlc';

    dataset
    {
        dataitem(UnknownTable61063;UnknownTable61063)
        {
            DataItemTableView = sorting("% Score") order(descending);
            RequestFilterFields = "Posistion Applied for";
            column(ReportForNavId_7560; 7560)
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
            column(Applicant_Details__Entry_No_;"Entry No")
            {
            }
            column(Applicant_Details__Applicant_First_Name_;"Applicant First Name")
            {
            }
            column(Applicant_Details__Applicant_Last_Name_;"Applicant Last Name")
            {
            }
            column(Applicant_Details__Application_Date_;"Application Date")
            {
            }
            column(Applicant_Details____Score_;"% Score")
            {
            }
            column(Shortlisted_Applicant_Caption;Shortlisted_Applicant_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Applicant_No_Caption;Applicant_No_CaptionLbl)
            {
            }
            column(Applicant_Details__Applicant_First_Name_Caption;FieldCaption("Applicant First Name"))
            {
            }
            column(Applicant_Details__Applicant_Last_Name_Caption;FieldCaption("Applicant Last Name"))
            {
            }
            column(Applicant_Details__Application_Date_Caption;FieldCaption("Application Date"))
            {
            }
            column(Applicant_Details____Score_Caption;FieldCaption("% Score"))
            {
            }

            trigger OnAfterGetRecord()
            begin

                  i:=i+1;
                  if Shortlisted<>0 then
                  begin
                  if i>Shortlisted then
                  CurrReport.Skip;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                  i:=0;
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

    trigger OnPreReport()
    begin
         PosistionApplied:="HRM-Applicant Details".GetFilter("HRM-Applicant Details"."Posistion Applied for");
         if  PosistionApplied='' then
          Error('You must specify posistion applied for filter');
          Applicant.SetRange("Posistion Applied for", PosistionApplied);
          if Applicant.Find('-') then begin
          repeat
           Applicant.CalcFields(Applicant."Actual Score");
           if Job.Get(Applicant."Posistion Applied for") then
            Job.CalcFields(Job."Total Score");
           if Applicant."Actual Score"<>0 then
            Applicant."% Score":=ROUND(Applicant."Actual Score"/Job."Total Score"*100,1,'>');
             Applicant.Modify;
            until Applicant.Next=0;
         end;
    end;

    var
        Job: Record UnknownRecord61056;
        Applicant: Record UnknownRecord61063;
        PosistionApplied: Code[10];
        Shortlisted: Integer;
        i: Integer;
        Shortlisted_Applicant_CaptionLbl: label 'Shortlisted Applicant ';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Applicant_No_CaptionLbl: label 'Applicant No.';
}

