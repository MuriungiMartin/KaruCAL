#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 9991 "Code Coverage Detailed"
{
    Caption = 'Code Coverage Detailed';
    Format = VariableText;

    schema
    {
        textelement(Coverage)
        {
            tableelement("Code Coverage";"Code Coverage")
            {
                XmlName = 'CodeCoverage';
                SourceTableView = where("Line Type"=const(Code),"No. of Hits"=filter(>0));
                fieldelement(ObjectType;"Code Coverage"."Object Type")
                {
                }
                fieldelement(ObjectID;"Code Coverage"."Object ID")
                {
                }
                fieldelement(LineNo;"Code Coverage"."Line No.")
                {
                }
                fieldelement(Hits;"Code Coverage"."No. of Hits")
                {
                }

                trigger OnBeforeInsertRecord()
                begin
                    "Code Coverage"."Line Type" := "Code Coverage"."line type"::Code;
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

    trigger OnInitXmlPort()
    begin
        currXMLport.ImportFile := false;
    end;

    trigger OnPostXmlPort()
    begin
        if currXMLport.ImportFile then
          CodeCoverageMgt.Import;
    end;

    trigger OnPreXmlPort()
    begin
        if currXMLport.ImportFile then begin
          "Code Coverage".Reset;
          CodeCoverageMgt.Clear;
        end;
    end;

    var
        CodeCoverageMgt: Codeunit "Code Coverage Mgt.";
}

