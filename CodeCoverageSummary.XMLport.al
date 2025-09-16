#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
XmlPort 9990 "Code Coverage Summary"
{
    Caption = 'Code Coverage Summary';
    Direction = Export;

    schema
    {
        textelement("<coverage>")
        {
            XmlName = 'Coverage';
            tableelement("Code Coverage";"Code Coverage")
            {
                XmlName = 'CodeCoverageObjects';
                SourceTableView = sorting("Object Type","Object ID","Line No.") order(ascending);
                fieldelement(LineType;"Code Coverage"."Line Type")
                {
                }
                fieldelement(ObjectType;"Code Coverage"."Object Type")
                {
                }
                fieldelement(ObjectID;"Code Coverage"."Object ID")
                {
                }
                textelement(ObjectName)
                {
                }
                textelement(LinesHit)
                {
                }
                textelement(Lines)
                {
                }
                textelement("<objectcoverage>")
                {
                    XmlName = 'Coverage';
                }

                trigger OnAfterGetRecord()
                var
                    TotalLines: Integer;
                    HitLines: Integer;
                begin
                    case "Code Coverage"."Line Type" of
                      "Code Coverage"."line type"::Object:
                        begin
                          ObjectName := "Code Coverage".Line;

                          "<ObjectCoverage>" := Format(CodeCoverageMgt.ObjectCoverage("Code Coverage",TotalLines,HitLines));
                        end;
                      "Code Coverage"."line type"::"Trigger/Function":
                        begin
                          ObjectName := "Code Coverage".Line;

                          "<ObjectCoverage>" := Format(CodeCoverageMgt.FunctionCoverage("Code Coverage",TotalLines,HitLines));
                        end;
                      else
                        currXMLport.Skip;
                    end;

                    LinesHit := Format(HitLines);
                    Lines := Format(TotalLines);
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

    var
        CodeCoverageMgt: Codeunit "Code Coverage Mgt.";
}

