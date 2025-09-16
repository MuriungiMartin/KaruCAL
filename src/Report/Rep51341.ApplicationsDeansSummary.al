#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51341 "Applications Deans Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Applications Deans Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61358;UnknownTable61358)
        {
            DataItemTableView = sorting(School1) where(Status=filter("Pending Approval"));
            RequestFilterFields = "Application No.",Status,"Admitted Degree","Academic Year";
            column(ReportForNavId_2953; 2953)
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
            column(Subj_1_;Subj[1])
            {
            }
            column(Subj_2_;Subj[2])
            {
            }
            column(Subj_4_;Subj[4])
            {
            }
            column(Subj_3_;Subj[3])
            {
            }
            column(Subj_6_;Subj[6])
            {
            }
            column(Subj_5_;Subj[5])
            {
            }
            column(Subj_8_;Subj[8])
            {
            }
            column(Subj_7_;Subj[7])
            {
            }
            column(Subj_10_;Subj[10])
            {
            }
            column(Subj_9_;Subj[9])
            {
            }
            column(Application_Form_Header_Faculty1;School1)
            {
            }
            column(Application_Form_Header__Application_No__;"Application No.")
            {
            }
            column(Application_Form_Header_Surname;Surname)
            {
            }
            column(Application_Form_Header__Other_Names_;"Other Names")
            {
            }
            column(Application_Form_Header_County;County)
            {
            }
            column(Application_Form_Header_Gender;Gender)
            {
            }
            column(Application_Form_Header__Mean_Grade_Acquired_;"Mean Grade Acquired")
            {
            }
            column(Gr_1_;Gr[1])
            {
            }
            column(Gr_2_;Gr[2])
            {
            }
            column(Gr_3_;Gr[3])
            {
            }
            column(Gr_6_;Gr[6])
            {
            }
            column(Gr_5_;Gr[5])
            {
            }
            column(Gr_4_;Gr[4])
            {
            }
            column(Gr_9_;Gr[9])
            {
            }
            column(Gr_8_;Gr[8])
            {
            }
            column(Gr_7_;Gr[7])
            {
            }
            column(Gr_10_;Gr[10])
            {
            }
            column(N;N)
            {
            }
            column(Deans_SummaryCaption;Deans_SummaryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Application_Form_Header__Application_No__Caption;FieldCaption("Application No."))
            {
            }
            column(Application_Form_Header_SurnameCaption;FieldCaption(Surname))
            {
            }
            column(Application_Form_Header__Other_Names_Caption;FieldCaption("Other Names"))
            {
            }
            column(Application_Form_Header_CountyCaption;FieldCaption(County))
            {
            }
            column(Application_Form_Header_GenderCaption;FieldCaption(Gender))
            {
            }
            column(Application_Form_Header__Mean_Grade_Acquired_Caption;FieldCaption("Mean Grade Acquired"))
            {
            }
            column(RemarksCaption;RemarksCaptionLbl)
            {
            }
            column(Application_Form_Header_Faculty1Caption;FieldCaption(School1))
            {
            }

            trigger OnAfterGetRecord()
            begin
                   for i:=1 to 20 do begin
                   AppSubj.Reset;
                   AppSubj.SetRange(AppSubj."Application No.","ACA-Applic. Form Header"."Application No.");
                   AppSubj.SetRange(AppSubj."Subject Code",Subj[i]);
                   if AppSubj.Find('-') then begin
                   repeat
                   Gr[i]:=AppSubj.Grade;
                   until AppSubj.Next=0;
                   end;
                   end;

                   N:=N+1;
            end;

            trigger OnPreDataItem()
            begin
                   SubjSetup.Reset;
                   SubjSetup.SetCurrentkey(SubjSetup."Sort No");
                   if SubjSetup.Find('-') then begin
                   repeat
                   if SubjSetup."Sort No">0 then begin
                   i:=i+1;
                   if i<20 then
                   Subj[i]:=SubjSetup.Code;
                   end;
                   until SubjSetup.Next=0;
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
        Subj: array [20] of Code[20];
        Gr: array [20] of Code[20];
        SubjSetup: Record UnknownRecord61363;
        AppSubj: Record UnknownRecord61362;
        i: Integer;
        N: Integer;
        Deans_SummaryCaptionLbl: label 'Deans Summary';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        RemarksCaptionLbl: label 'Remarks';
}

