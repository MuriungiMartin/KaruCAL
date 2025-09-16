#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 507 "XBRL Copy Setup"
{
    Caption = 'XBRL Copy Setup';
    ProcessingOnly = true;

    dataset
    {
        dataitem(FromXBRLLine;"XBRL Taxonomy Line")
        {
            DataItemTableView = sorting("XBRL Taxonomy Name","Line No.");
            column(ReportForNavId_6023; 6023)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Progress := Progress + 1;
                T1 := Time;
                if T1 > T0 + 250 then begin
                  Window.Update(1,ROUND(Progress * 10000 / NoOfRecords,1));
                  T0 := Time;
                  T1 := T0;
                end;

                ToXBRLLine.SetRange(Name,Name);
                if ToXBRLLine.FindFirst then begin
                  ToXBRLLine.Description := Description;
                  ToXBRLLine."Constant Amount" := "Constant Amount";
                  ToXBRLLine."Source Type" := "Source Type";
                  ToXBRLLine.Modify;

                  FromXBRLCommentLine.SetRange("XBRL Taxonomy Name","XBRL Taxonomy Name");
                  FromXBRLCommentLine.SetRange("XBRL Taxonomy Line No.","Line No.");
                  FromXBRLCommentLine.SetRange("Comment Type",FromXBRLCommentLine."comment type"::Notes);
                  if FromXBRLCommentLine.Find('-') then
                    repeat
                      ToXBRLCommentLine := FromXBRLCommentLine;
                      ToXBRLCommentLine."XBRL Taxonomy Name" := ToXBRLLine."XBRL Taxonomy Name";
                      ToXBRLCommentLine."XBRL Taxonomy Line No." := ToXBRLLine."Line No.";
                      if ToXBRLCommentLine.Insert then;
                    until FromXBRLCommentLine.Next = 0;

                  FromXBRLGLMapLine.SetRange("XBRL Taxonomy Name","XBRL Taxonomy Name");
                  FromXBRLGLMapLine.SetRange("XBRL Taxonomy Line No.","Line No.");
                  if FromXBRLGLMapLine.Find('-') then
                    repeat
                      ToXBRLGLMapLine := FromXBRLGLMapLine;
                      ToXBRLGLMapLine."XBRL Taxonomy Name" := ToXBRLLine."XBRL Taxonomy Name";
                      ToXBRLGLMapLine."XBRL Taxonomy Line No." := ToXBRLLine."Line No.";
                      if ToXBRLGLMapLine.Insert then;
                    until FromXBRLGLMapLine.Next = 0;
                end else
                  CurrReport.Skip;
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("XBRL Taxonomy Name",FromTaxonomyName);
                ToXBRLLine.SetCurrentkey(Name);
                ToXBRLLine.SetRange("XBRL Taxonomy Name",ToTaxonomyName);
                NoOfRecords := Count;
                Window.Open(Text001);
                T0 := Time;
                T1 := T0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FromTaxonomyName;FromTaxonomyName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'From Taxonomy Name';
                        ToolTip = 'Specifies the taxonomy from which you want to copy the setup.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(LookupTaxonomy(Text));
                        end;

                        trigger OnValidate()
                        begin
                            ValidateTaxonomy(FromTaxonomyName);
                        end;
                    }
                    field(ToTaxonomyName;ToTaxonomyName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'To Taxonomy Name';
                        ToolTip = 'Specifies the taxonomy to which you want to copy the setup.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            exit(LookupTaxonomy(Text));
                        end;

                        trigger OnValidate()
                        begin
                            ValidateTaxonomy(ToTaxonomyName);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if FromTaxonomyName = '' then
          Error(Text002);
        if ToTaxonomyName = '' then
          Error(Text003);
        if FromTaxonomyName = ToTaxonomyName then
          Error(Text004);
    end;

    var
        ToXBRLLine: Record "XBRL Taxonomy Line";
        FromXBRLCommentLine: Record "XBRL Comment Line";
        ToXBRLCommentLine: Record "XBRL Comment Line";
        FromXBRLGLMapLine: Record "XBRL G/L Map Line";
        ToXBRLGLMapLine: Record "XBRL G/L Map Line";
        Window: Dialog;
        FromTaxonomyName: Code[20];
        ToTaxonomyName: Code[20];
        NoOfRecords: Integer;
        Progress: Integer;
        Text001: label 'Copying Setup @1@@@@@@@@';
        T0: Time;
        T1: Time;
        Text002: label 'You must enter a From Taxonomy Name.';
        Text003: label 'You must enter a To Taxonomy Name.';
        Text004: label 'To and From Taxonomy Names must be different.';

    local procedure LookupTaxonomy(var Text: Text[1024]): Boolean
    var
        XBRLTaxonomy: Record "XBRL Taxonomy";
        XBRLTaxonomies: Page "XBRL Taxonomies";
    begin
        XBRLTaxonomy.Name := CopyStr(Text,1,MaxStrLen(XBRLTaxonomy.Name));
        if XBRLTaxonomy.Find('=<>') then;
        XBRLTaxonomies.SetRecord(XBRLTaxonomy);
        XBRLTaxonomies.LookupMode := true;
        if XBRLTaxonomies.RunModal = Action::LookupOK then begin
          XBRLTaxonomies.GetRecord(XBRLTaxonomy);
          Text := XBRLTaxonomy.Name;
          exit(true);
        end;
        exit(false);
    end;

    local procedure ValidateTaxonomy(TaxonomyName: Code[20])
    var
        XBRLTaxonomy: Record "XBRL Taxonomy";
    begin
        XBRLTaxonomy.Get(TaxonomyName);
    end;


    procedure SetCopyTo(NewToTaxonomyName: Code[20])
    begin
        ToTaxonomyName := NewToTaxonomyName;
    end;
}

