#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51472 "Summary By Gender"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Summary By Gender.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
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
            column(malecount;malecount)
            {
            }
            column(femalecount;femalecount)
            {
            }
            column(totalno;totalno)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(No__Of__Male_StudentsCaption;No__Of__Male_StudentsCaptionLbl)
            {
            }
            column(No__Of__Male_StudentsCaption_Control1102760010;No__Of__Male_StudentsCaption_Control1102760010Lbl)
            {
            }
            column(Total_No_of_StudentsCaption;Total_No_of_StudentsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                malecount:=0;
                femalecount:=0;
                totalno:=0;

                custrec.SetRange(custrec."Student Programme","ACA-Programme".Code);
                custrec.SetRange(custrec.Status,custrec.Status::Current);
                custrec.CalcFields(custrec."Student Programme");
                if custrec.Find('-') then begin

                repeat
                if custrec.Gender=custrec.Gender::" " then
                  begin
                  malecount:=malecount+1;
                  end
                else
                  begin
                  femalecount:=femalecount+1;
                  end;
                  totalno:=malecount+femalecount;
                until custrec.Next=0;
                end;
            end;

            trigger OnPreDataItem()
            begin
                //malecount:=0;
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
        progrec: Record UnknownRecord61511;
        malecount: Integer;
        femalecount: Integer;
        custrec: Record Customer;
        totalno: Integer;
        ProgrammeCaptionLbl: label 'Programme';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        No__Of__Male_StudentsCaptionLbl: label 'No. Of  Male Students';
        No__Of__Male_StudentsCaption_Control1102760010Lbl: label 'No. Of  Male Students';
        Total_No_of_StudentsCaptionLbl: label 'Total No of Students';
}

