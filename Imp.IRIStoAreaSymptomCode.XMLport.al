#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 5900 "Imp. IRIS to Area/Symptom Code"
{
    Caption = 'Imp. IRIS to Area/Symptom Code';
    Direction = Import;
    Format = VariableText;
    UseRequestPage = false;

    schema
    {
        textelement(Root)
        {
            tableelement("Fault Area/Symptom Code";"Fault Area/Symptom Code")
            {
                XmlName = 'Import';
                UseTemporary = true;
                fieldelement(Type;"Fault Area/Symptom Code".Type)
                {
                }
                fieldelement(Code;"Fault Area/Symptom Code".Code)
                {
                }
                fieldelement(Description;"Fault Area/Symptom Code".Description)
                {
                }

                trigger OnBeforeInsertRecord()
                var
                    FaultArea: Record "Fault Area";
                    SymptCode: Record "Symptom Code";
                begin
                    case "Fault Area/Symptom Code".Type of
                      "Fault Area/Symptom Code".Type::"Fault Area":
                        begin
                          FaultArea.Init;
                          FaultArea.Code := "Fault Area/Symptom Code".Code;
                          FaultArea.Description := "Fault Area/Symptom Code".Description;
                          if not FaultArea.Insert then
                            FaultArea.Modify;
                          Counter += 1;
                        end;
                      "Fault Area/Symptom Code".Type::"Symptom Code":
                        begin
                          SymptCode.Init;
                          SymptCode.Code := "Fault Area/Symptom Code".Code;
                          SymptCode.Description := "Fault Area/Symptom Code".Description;
                          if not SymptCode.Insert then
                            SymptCode.Modify;
                          Counter += 1;
                        end;
                    end;
                end;
            }
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

    trigger OnPostXmlPort()
    begin
        Message(Text001,Counter);
    end;

    var
        Counter: Integer;
        Text001: label '%1 records were successfully inserted or modified.';
}

