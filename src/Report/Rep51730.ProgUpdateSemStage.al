#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51730 "Prog Update Sem/Stage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Prog Update SemStage.rdlc';

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(PC;"ACA-Programme".Code)
            {
            }
            column(PD;"ACA-Programme".Description)
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Prog.Find("ACA-Programme".Code) then begin
                //REPEAT

                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y1S1';
                ProgStage.Description:='Year 1 Semester1';
                ProgStage.Remarks:='Pass, Proceed to Second Year';
                ProgStage.Insert;
                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y1S2';
                ProgStage.Description:='Year 1 Semester2';
                ProgStage.Remarks:='Pass, Proceed to Second Year';
                ProgStage.Insert;
                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y2S1';
                ProgStage.Description:='Year 2 Semester1';
                ProgStage.Remarks:='Pass, Proceed to Third Year';
                ProgStage.Insert;

                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y2S2';
                ProgStage.Description:='Year 2 Semester2';
                ProgStage.Remarks:='Pass, Proceed to Third Year';
                ProgStage.Insert;
                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y3S1';
                ProgStage.Description:='Year 3 Semester1';
                ProgStage.Remarks:='Pass, Proceed to Forth Year';
                ProgStage.Insert;

                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y3S2';
                ProgStage.Description:='Year 3 Semester2';
                ProgStage.Remarks:='Pass, Proceed to Second Year';
                ProgStage.Insert;

                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y4S1';
                ProgStage.Description:='Year 4 Semester1';
                ProgStage.Remarks:='Pass ';
                ProgStage.Insert;

                ProgStage.Init;
                ProgStage."Programme Code":=Prog.Code;
                ProgStage.Code:='Y4S2';
                ProgStage.Description:='Year 4 Semester2';
                ProgStage.Remarks:='Pass ';
                ProgStage.Insert;

                ProgSem.Init;
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Semester:='Sem1 09/10';
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem2 09/10';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem1 10/11';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem2 10/11';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem1 11/12';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem2 11/12';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem1 12/13';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem2 12/13';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem1 13/14';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem2 13/14';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Insert;
                ProgSem.Init;
                ProgSem.Semester:='Sem1 14/15';
                ProgSem."Programme Code":=Prog.Code;
                ProgSem.Semester:='Sem1 14/15';
                ProgSem.Insert;
                //UNTIL Prog.NEXT=0;
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
        Prog: Record UnknownRecord61511;
        ProgSem: Record UnknownRecord61525;
        ProgStage: Record UnknownRecord61516;
}

