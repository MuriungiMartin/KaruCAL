#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51861 "ACA-Units/Subjects proc"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61517;UnknownTable61517)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(strLenths);
                Clear(CurrPos);
                Clear(NewStr);
                if "ACA-Units/Subjects".Desription<>'' then begin
                  strLenths:=StrLen("ACA-Units/Subjects".Desription);
                  repeat
                    begin
                    CurrPos:=CurrPos+1;
                    if (CopyStr("ACA-Units/Subjects".Desription,CurrPos,1))<>',' then NewStr:=NewStr+(CopyStr("ACA-Units/Subjects".Desription,CurrPos,1));
                    end;
                    until CurrPos=strLenths;
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
        strLenths: Integer;
        CurrPos: Integer;
        NewStr: Code[150];
}

