#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51669 "Students Enrolment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Students Enrolment.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            DataItemTableView = sorting(Category) where("Student Registered"=filter(>0));
            RequestFilterFields = Category,"Semester Filter","Norminal Registered";
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
            column(YR_1_;YR[1])
            {
            }
            column(YR_2_;YR[2])
            {
            }
            column(YR_3_;YR[3])
            {
            }
            column(YR_4_;YR[4])
            {
            }
            column(YR_5_;YR[5])
            {
            }
            column(JAB__________SSP_;'JAB          SSP')
            {
            }
            column(JAB__________SSP__Control1102755042;'JAB          SSP')
            {
            }
            column(JAB__________SSP__Control1102755043;'JAB          SSP')
            {
            }
            column(JAB__________SSP__Control1102755044;'JAB          SSP')
            {
            }
            column(JAB__________SSP__Control1102755045;'JAB          SSP')
            {
            }
            column(M_________F_;'M         F')
            {
            }
            column(M_________F__Control1102755047;'M         F')
            {
            }
            column(M_________F__Control1102755048;'M         F')
            {
            }
            column(M_________F__Control1102755049;'M         F')
            {
            }
            column(M_________F__Control1102755050;'M         F')
            {
            }
            column(TOTALS_;'TOTALS')
            {
            }
            column(JAB__________SSP__Control1102755027;'JAB          SSP')
            {
            }
            column(M_________F__Control1102755028;'M         F')
            {
            }
            column(Programme_Category;Category)
            {
            }
            column(Programme_Code;Code)
            {
            }
            column(Programme_Description;Description)
            {
            }
            column(JF_5_;JF[5])
            {
            }
            column(JF_5__Control1102755032;JF[5])
            {
            }
            column(JF_4_;JF[4])
            {
            }
            column(JF_4__Control1102755034;JF[4])
            {
            }
            column(JF_3_;JF[3])
            {
            }
            column(JF_3__Control1102755036;JF[3])
            {
            }
            column(JF_2_;JF[2])
            {
            }
            column(JF_2__Control1102755038;JF[2])
            {
            }
            column(JF_1_;JF[1])
            {
            }
            column(JM_1_;JM[1])
            {
            }
            column(JF_5__JF_4__JF_3__JF_2__JF_1_;JF[5]+JF[4]+JF[3]+JF[2]+JF[1])
            {
            }
            column(JF_5__JF_4__JF_3__JF_2__JF_1__Control1102755030;JF[5]+JF[4]+JF[3]+JF[2]+JF[1])
            {
            }
            column(JFT_5_;JFT[5])
            {
            }
            column(JFT_5__Control1102755017;JFT[5])
            {
            }
            column(JFT_4_;JFT[4])
            {
            }
            column(JFT_4__Control1102755019;JFT[4])
            {
            }
            column(JFT_3_;JFT[3])
            {
            }
            column(JFT_3__Control1102755021;JFT[3])
            {
            }
            column(JFT_2_;JFT[2])
            {
            }
            column(JFT_2__Control1102755023;JFT[2])
            {
            }
            column(JFT_1_;JFT[1])
            {
            }
            column(JMT_1_;JMT[1])
            {
            }
            column(JFT_5__JFT_4__JFT_3__JFT_2__JFT_1_;JFT[5]+JFT[4]+JFT[3]+JFT[2]+JFT[1])
            {
            }
            column(JFT_5__JFT_4__JFT_3__JFT_2__JFT_1__Control1102755052;JFT[5]+JFT[4]+JFT[3]+JFT[2]+JFT[1])
            {
            }
            column(STUDENTS_ENROLMENT_STATISTICSCaption;STUDENTS_ENROLMENT_STATISTICSCaptionLbl)
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

            trigger OnAfterGetRecord()
            begin
                 for i:=1 to 5 do begin
                 Prog.Reset;
                 Prog.SetRange(Prog.Code,"ACA-Programme".Code);
                 Prog.SetFilter(Prog."Semester Filter","ACA-Programme".GetFilter("Semester Filter"));
                 Prog.SetFilter(Prog."Study Year Filter",YRCode[i]);
                // Prog.setfilter(Prog."Settlement Type Filter",'JAB');
                 if Prog.Find('-') then begin
                 Prog.CalcFields(Prog."Total JAB Female");
                 Prog.CalcFields(Prog."Total JAB Male");
                 Prog.CalcFields(Prog."Total SSP Female");
                 Prog.CalcFields(Prog."Total SSP Male");

                 JM[i]:=Prog."Total JAB Female";
                 JF[i]:=Prog."Total JAB Male";
                 SF[i]:=Prog."Total SSP Female";
                 SM[i]:=Prog."Total SSP Male";

                 JMT[i]:=JMT[i]+Prog."Total JAB Female";
                 JFT[i]:=JFT[i]+Prog."Total JAB Male";
                 SFT[i]:=SFT[i]+Prog."Total SSP Female";
                 SMT[i]:=SMT[i]+Prog."Total SSP Male";

                 end;
                 end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Category);

                StudyYear.Reset;
                //StudyYear.SETRANGE(StudyYear.Unit,TRUE);
                if StudyYear.Find('-') then begin
                repeat
                i:=i+1;
                YRCode[i]:=StudyYear.Programme;
                YR[i]:=StudyYear.Stage;
                until StudyYear.Next=0;
                end;

                Creg.Reset;
                Creg.SetFilter(Creg.Programme,"ACA-Programme".GetFilter("ACA-Programme".Code));
                Creg.SetFilter(Creg.Semester,"ACA-Programme".GetFilter("ACA-Programme"."Semester Filter"));
                if Creg.Find('-') then begin
                repeat
                if StrLen(Creg."Student No.")>1 then begin
                //Creg."Sem Pass Count":=COPYSTR(Creg."Student No.",(STRLEN(Creg."Student No.")-1),STRLEN(Creg."Student No."));
                //Creg.MODIFY;
                end;
                until Creg.Next=0;
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        StudyYear: Record UnknownRecord61548;
        YR: array [100] of Code[20];
        JM: array [100] of Integer;
        JF: array [100] of Integer;
        SM: array [100] of Integer;
        SF: array [100] of Integer;
        i: Integer;
        YRCode: array [100] of Code[20];
        Creg: Record UnknownRecord61532;
        Prog: Record UnknownRecord61511;
        JMT: array [100] of Integer;
        JFT: array [100] of Integer;
        SMT: array [100] of Integer;
        SFT: array [100] of Integer;
        STUDENTS_ENROLMENT_STATISTICSCaptionLbl: label 'STUDENTS ENROLMENT STATISTICS';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

