#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51493 "Summary Enrollment - Stage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Summary Enrollment - Stage.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Code) where(Registered=filter(>0));
            RequestFilterFields = "Code","Stage Filter","Semester Filter","Student Type Filter",Faculty,"School Code","Date Filter",Status,"Total JAB Female";
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
            column(TIME;Time)
            {
            }
            column(Sems;Sems)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(Programme__Student_Registered_;"Student Registered")
            {
            }
            column(StReg;StReg)
            {
            }
            column(Summary_Enrollment_By_ProgrammeCaption;Summary_Enrollment_By_ProgrammeCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Filters_Caption;Filters_CaptionLbl)
            {
            }
            column(Programme_CodeCaption;FieldCaption(Code))
            {
            }
            column(Programme_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Programme__Student_Registered_Caption;FieldCaption("Student Registered"))
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }
            column(TotalBilled;TBilled)
            {
            }
            column(Paid;Paid1)
            {
            }
            column(Billed;Billed)
            {
            }
            column(BalancePerc;"b%")
            {
            }
            column(TotalPerc;"T%")
            {
            }
            column(Balance;Bal)
            {
            }
            column(School;"ACA-Programme"."School Code")
            {
            }
            column(Logo;CompInf.Picture)
            {
            }
            column(CompName;CompInf.Name)
            {
            }
            column(FacultyName;FacultyName)
            {
            }
            dataitem(UnknownTable61516;UnknownTable61516)
            {
                DataItemLink = "Programme Code"=field(Code);
                column(ReportForNavId_11; 11)
                {
                }
                column(Code_ProgrammeStages;"ACA-Programme Stages".Code)
                {
                }
                column(Description_ProgrammeStages;"ACA-Programme Stages".Description)
                {
                }
                column(StudentRegistered_ProgrammeStages;"ACA-Programme Stages"."Student Registered")
                {
                }

                trigger OnAfterGetRecord()
                begin
                       StudT:=StudT+"ACA-Programme Stages"."Student Registered";
                      StReg:=StudT;
                      Billed:=0;
                      Paid:=0;
                      Paid1:=0;
                      "T%":=0;
                      "b%":=0;
                      Bal:=0;
                      Creg.Reset;
                      Creg.SetFilter(Creg.Programme,"ACA-Programme".Code);
                      Creg.SetFilter(Creg.Semester,"ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                      Creg.SetRange(Creg.Stage,"ACA-Programme Stages".Code);
                      //Creg.SETFILTER(Creg."Branch Filter",Programme.GETFILTER(Programme."Branch Filter"));
                    //  Creg.SETFILTER(Creg."Programme Category",Programme.GETFILTER(Programme.Category));
                     // Creg.SETFILTER(Creg."Register for",Programme.GETFILTER(Programme."Register For Filter"));
                      Creg.SetRange(Creg.Posted,true);
                      Creg.SetRange(Creg.Reversed,false);
                    
                     // IF "Filter Options"="Filter Options"::Ledgers THEN
                    //  Creg.SETFILTER(Creg."Date Filter",'%1..%2',Sem.From,Sem."To");
                      Creg.SetRange(Creg.Posted,true);
                      Creg.SetRange(Creg.Reversed,false);
                      if Creg.Find('-') then begin
                      repeat
                     /*
                     // IF "Filter Options"="Filter Options"::Registration THEN BEGIN
                     // Creg.CALCFIELDS(Creg."Total Receipted");
                      Creg.CALCFIELDS(Creg."Billed Amount");
                      Creg.CALCFIELDS(Creg.Balance);
                      Billed:=Billed+Creg."Billed Amount";
                      Paid1:=Paid1+Creg."Total Receipted";
                     // Paid:=Paid1;
                      TBilled:=TBilled+Creg."Billed Amount";
                      TPaid:=TPaid+Creg."Total Receipted";
                    
                      END ELSE BEGIN
                      */
                      Creg.CalcFields(Creg."Total Billed");
                      Creg.CalcFields(Creg."Total Paid");
                      Creg.CalcFields(Creg.Balance);
                      Billed:=Billed+Creg."Total Billed";
                      Paid1:=Paid1+Creg."Total Paid";
                      TBilled:=TBilled+Creg."Total Billed";
                      TPaid:=TPaid+Creg."Total Paid";
                     // END;
                      Bal:=Billed-Paid1;
                      if (Paid1<>0) and (Billed<>0) then
                      "b%":=(Paid/Billed)*100;
                      until Creg.Next=0;
                      end;
                      if (TPaid<>0) and (TBilled<>0) then
                      "T%":=(TPaid/TBilled)*100;

                end;
            }

            trigger OnAfterGetRecord()
            begin
                DimmRec.Reset;
                DimmRec.SetRange(DimmRec.Code,"ACA-Programme"."School Code");
                if DimmRec.Find('-') then begin
                FacultyName:=DimmRec.Name;
                end;

                "ACA-Programme".CalcFields("ACA-Programme"."Full Time Budget");
                "ACA-Programme".CalcFields("ACA-Programme"."Part Time Budget");
                TotRegPartTime:=TotRegPartTime+"Registered Part Time";
                TotfullTime:=TotfullTime+"Registered Full Time";
                StReg:=StReg+"Student Registered";
                PaidParttime:=PaidParttime+"Paid Part Time";
                PaidFullTime:=PaidFullTime+"Paid Full Time";
                TotPaid:=TotPaid+Paid;
                TBudget:=TBudget+"ACA-Programme"."Full Time Budget"+"ACA-Programme"."Part Time Budget";
                TBFull:=TBFull+"ACA-Programme"."Full Time Budget";
                TBPart:=TBPart+"ACA-Programme"."Part Time Budget";
            end;

            trigger OnPreDataItem()
            begin
                Sems:="ACA-Programme".GetFilter("ACA-Programme"."Semester Filter");

                 TotRegPartTime:=0;
                 TotfullTime:=0;
                 StReg:=0;
                 PaidParttime:=0;
                 PaidFullTime:=0;
                 TotPaid:=0;

                CompInf.Get;
                //CompInf.CALCFIELDS(CompInf.Picture);
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
        Summary_Enrollment_By_ProgrammeCaptionLbl: label 'Summary Enrollment By Programme';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Filters_CaptionLbl: label 'Filters:';
        TotalsCaptionLbl: label 'Totals';
        TotfullTime: Decimal;
        TotRegPartTime: Decimal;
        StReg: Decimal;
        PaidParttime: Decimal;
        PaidFullTime: Decimal;
        TotPaid: Decimal;
        Prog: Text[250];
        TBudget: Decimal;
        TBFull: Decimal;
        TBPart: Decimal;
        Creg: Record UnknownRecord61532;
        StudT: Decimal;
        TBilled: Decimal;
        TPaid: Decimal;
        Paid: Decimal;
        Billed: Decimal;
        Receipts: Record UnknownRecord61538;
        "b%": Decimal;
        "T%": Decimal;
        Sem: Record UnknownRecord61518;
        "Filter Options": Option Registration,Ledgers;
        Paid1: Decimal;
        Sems: Code[20];
        Bal: Decimal;
        CompInf: Record "Company Information";
        DimmRec: Record "Dimension Value";
        FacultyName: Text[100];
}

