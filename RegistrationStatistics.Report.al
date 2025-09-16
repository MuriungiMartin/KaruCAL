#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51286 "Registration Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Registration Statistics.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            RequestFilterFields = "Stage Filter","Settlement Type Filter";
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(Description;"ACA-Programme".Description)
            {
            }
            column(JabMale;"ACA-Programme"."Total JAB Male")
            {
            }
            column(JabFemale;"ACA-Programme"."Total JAB Female")
            {
            }
            column(ProgJabTotal;ProgJabTotal)
            {
            }
            column(SSPMale;"ACA-Programme"."Total SSP Male")
            {
            }
            column(SSPFemale;"ACA-Programme"."Total SSP Female")
            {
            }
            column(ProgSSPTotal;ProgSSPTotal)
            {
            }
            column(ProgTotal;progTotal)
            {
            }
            column(JabGrandTotal;jabGrangTotal)
            {
            }
            column(SSPGrandTotal;SspGrandTotal)
            {
            }
            column(OverallTotal;OveralTotal)
            {
            }
            column(SchoolCode;"ACA-Programme"."School Code")
            {
            }
            column(SchoolName;SchoolName)
            {
            }
            column(JMale;JabMale)
            {
            }
            column(JFemale;JabFemale)
            {
            }
            column(SMale;SSPMale)
            {
            }
            column(SFemale;SSPFemale)
            {
            }

            trigger OnAfterGetRecord()
            begin
                DimVal.Reset;
                DimVal.SetRange(DimVal.Code,"ACA-Programme"."School Code");
                if DimVal.Find('-') then begin
                SchoolName:=DimVal.Name;
                end;

                JabMale:=0;
                JabFemale:=0;
                SSPMale:=0;
                SSPFemale:=0;

                CourseReg.Reset;
                CourseReg.SetRange(CourseReg.Programme,"ACA-Programme".Code);
                CourseReg.SetRange(CourseReg."Settlement Type",'JAB');
                CourseReg.SetRange(CourseReg.Gender,CourseReg.Gender::Male);
                CourseReg.SetRange(CourseReg.Reversed,false);
                CourseReg.SetRange(CourseReg."Current Sem",true);
                if CourseReg.Find('-') then begin
                CourseReg.SetFilter(CourseReg.Stage,"ACA-Programme".GetFilter("ACA-Programme"."Stage Filter"));
                CourseReg.LockTable;
                JabMale:=CourseReg.Count;
                end;

                CourseReg.Reset;
                CourseReg.SetRange(CourseReg.Programme,"ACA-Programme".Code);
                CourseReg.SetRange(CourseReg."Settlement Type",'JAB');
                CourseReg.SetRange(CourseReg.Gender,CourseReg.Gender::Female);
                CourseReg.SetRange(CourseReg.Reversed,false);
                CourseReg.SetRange(CourseReg."Current Sem",true);
                if CourseReg.Find('-') then begin
                CourseReg.SetFilter(CourseReg.Stage,"ACA-Programme".GetFilter("ACA-Programme"."Stage Filter"));
                CourseReg.LockTable;
                JabFemale:=CourseReg.Count;
                end;

                CourseReg.Reset;
                CourseReg.SetRange(CourseReg.Programme,"ACA-Programme".Code);
                CourseReg.SetRange(CourseReg."Settlement Type",'SSP');
                CourseReg.SetRange(CourseReg.Gender,CourseReg.Gender::Male);
                CourseReg.SetRange(CourseReg.Reversed,false);
                CourseReg.SetRange(CourseReg."Current Sem",true);
                if CourseReg.Find('-') then begin
                CourseReg.SetFilter(CourseReg.Stage,"ACA-Programme".GetFilter("ACA-Programme"."Stage Filter"));
                CourseReg.LockTable;
                SSPMale:=CourseReg.Count;
                end;

                CourseReg.Reset;
                CourseReg.SetRange(CourseReg.Programme,"ACA-Programme".Code);
                CourseReg.SetRange(CourseReg."Settlement Type",'SSP');
                CourseReg.SetRange(CourseReg.Gender,CourseReg.Gender::Female);
                CourseReg.SetRange(CourseReg.Reversed,false);
                CourseReg.SetRange(CourseReg."Current Sem",true);
                if CourseReg.Find('-') then begin
                CourseReg.SetFilter(CourseReg.Stage,"ACA-Programme".GetFilter("ACA-Programme"."Stage Filter"));
                CourseReg.LockTable;
                SSPFemale:=CourseReg.Count;
                end;

                 Clear(progTotal);
                 Clear(ProgSSPTotal);
                 Clear(ProgJabTotal);
                 ProgJabTotal:=JabMale+JabFemale;
                 ProgSSPTotal:=SSPMale+SSPFemale;
                 progTotal:=ProgSSPTotal+ProgJabTotal;

                if (JabMale=0) and (JabFemale=0) and (SSPMale=0) and (JabFemale=0) then
                CurrReport.Skip;
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
        ProgJabTotal: Decimal;
        SchlJabTotal: Decimal;
        ProgSSPTotal: Decimal;
        SchlSSPTotal: Decimal;
        progTotal: Decimal;
        jabGrangTotal: Decimal;
        SspGrandTotal: Decimal;
        OveralTotal: Decimal;
        SchoolName: Text[150];
        DimVal: Record "Dimension Value";
        CourseReg: Record UnknownRecord61532;
        JabMale: Integer;
        JabFemale: Integer;
        SSPMale: Integer;
        SSPFemale: Integer;
}

