#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 80060 "Validate Programme"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61511;UnknownTable61511)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ACADefinedUnitsperYoS.Reset;
                ACADefinedUnitsperYoS.SetRange(Programme,"ACA-Programme".Code);
                ACADefinedUnitsperYoS.SetRange("Year of Study",1);
                if not (ACADefinedUnitsperYoS.Find('-')) then begin
                  ACADefinedUnitsperYoS.Init;
                  ACADefinedUnitsperYoS.Programme:="ACA-Programme".Code;
                  ACADefinedUnitsperYoS."Year of Study":=1;
                  ACADefinedUnitsperYoS.Insert;
                  end;

                ACADefinedUnitsperYoS.Reset;
                ACADefinedUnitsperYoS.SetRange(Programme,"ACA-Programme".Code);
                ACADefinedUnitsperYoS.SetRange("Year of Study",2);
                if not (ACADefinedUnitsperYoS.Find('-')) then begin
                  ACADefinedUnitsperYoS.Init;
                  ACADefinedUnitsperYoS.Programme:="ACA-Programme".Code;
                  ACADefinedUnitsperYoS."Year of Study":=2;
                  ACADefinedUnitsperYoS.Insert;
                  end;

                ACADefinedUnitsperYoS.Reset;
                ACADefinedUnitsperYoS.SetRange(Programme,"ACA-Programme".Code);
                ACADefinedUnitsperYoS.SetRange("Year of Study",3);
                if not (ACADefinedUnitsperYoS.Find('-')) then begin
                  ACADefinedUnitsperYoS.Init;
                  ACADefinedUnitsperYoS.Programme:="ACA-Programme".Code;
                  ACADefinedUnitsperYoS."Year of Study":=3;
                  ACADefinedUnitsperYoS.Insert;
                  end;

                ACADefinedUnitsperYoS.Reset;
                ACADefinedUnitsperYoS.SetRange(Programme,"ACA-Programme".Code);
                ACADefinedUnitsperYoS.SetRange("Year of Study",4);
                if not (ACADefinedUnitsperYoS.Find('-')) then begin
                  ACADefinedUnitsperYoS.Init;
                  ACADefinedUnitsperYoS.Programme:="ACA-Programme".Code;
                  ACADefinedUnitsperYoS."Year of Study":=4;
                  ACADefinedUnitsperYoS.Insert;
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
        ACADefinedUnitsperYoS: Record UnknownRecord78017;
}

