#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 476 "Copy Tax Setup"
{
    ApplicationArea = Basic;
    Caption = 'Copy Tax Setup';
    PageType = StandardDialog;
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("SourceCompany.Name";SourceCompany.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'From Company';
                    Lookup = true;
                    LookupPageID = Companies;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        SourceCompany.SetFilter(Name,'<>%1',COMPANYNAME);
                        if Page.RunModal(Page::Companies,SourceCompany) = Action::LookupOK then
                          if SourceCompany.Name = COMPANYNAME then begin
                            SourceCompany.Name := '';
                            Error(Text000);
                          end;
                    end;
                }
                field(CopyMode;CopyMode)
                {
                    ApplicationArea = Basic;
                    OptionCaption = 'Copy All Setup Information,Copy Selected Information:';

                    trigger OnValidate()
                    begin
                        if CopyMode = Copymode::Custom then
                          CustomCopyModeOnValidate;
                        if CopyMode = Copymode::All then
                          AllCopyModeOnValidate;
                    end;
                }
                field(TaxGroups;CopyTable[1])
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Groups';
                    Enabled = TaxGroupsEnable;

                    trigger OnValidate()
                    begin
                        CopyTable1OnPush;
                    end;
                }
                field(TaxJurisdictions;CopyTable[2])
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Jurisdictions';
                    Enabled = TaxJurisdictionsEnable;

                    trigger OnValidate()
                    begin
                        CopyTable2OnPush;
                    end;
                }
                field(TaxAreas;CopyTable[3])
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Areas';
                    Enabled = TaxAreasEnable;

                    trigger OnValidate()
                    begin
                        CopyTable3OnPush;
                    end;
                }
                field(TaxDetail;CopyTable[4])
                {
                    ApplicationArea = Basic;
                    Caption = 'Tax Detail';
                    Enabled = TaxDetailEnable;

                    trigger OnValidate()
                    begin
                        CopyTable4OnPush;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        TaxDetailEnable := true;
        TaxAreasEnable := true;
        TaxJurisdictionsEnable := true;
        TaxGroupsEnable := true;
    end;

    trigger OnOpenPage()
    begin
        for i := 1 to ArrayLen(CopyTable) do
          CopyTable[i] := true;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then
          OKOnPush;
    end;

    var
        Text000: label 'You must select a company other than the current company.';
        Text001: label 'You must select a company from which to copy.';
        Text002: label 'Nothing was selected to copy.\You must select one or more tables to copy.';
        SourceCompany: Record Company;
        CopyTaxSetup: Codeunit "Copy Tax Setup From Company";
        CopyTable: array [4] of Boolean;
        i: Integer;
        CopyMode: Option All,Custom;
        [InDataSet]
        TaxGroupsEnable: Boolean;
        [InDataSet]
        TaxJurisdictionsEnable: Boolean;
        [InDataSet]
        TaxAreasEnable: Boolean;
        [InDataSet]
        TaxDetailEnable: Boolean;

    local procedure CopyTable1OnPush()
    begin
        CopyMode := Copymode::Custom;
    end;

    local procedure CopyTable2OnPush()
    begin
        CopyMode := Copymode::Custom;
    end;

    local procedure CopyTable3OnPush()
    begin
        CopyMode := Copymode::Custom;
    end;

    local procedure CopyTable4OnPush()
    begin
        CopyMode := Copymode::Custom;
    end;

    local procedure AllCopyModeOnPush()
    begin
        for i := 1 to ArrayLen(CopyTable) do
          CopyTable[i] := true;
    end;

    local procedure CustomCopyModeOnPush()
    begin
        TaxGroupsEnable := true;
        TaxJurisdictionsEnable := true;
        TaxAreasEnable := true;
        TaxDetailEnable := true;
    end;

    local procedure OKOnPush()
    begin
        if SourceCompany.Name = '' then
          Error(Text001);

        if not CopyTable[1] and not CopyTable[2] and not CopyTable[3] and not CopyTable[4] then
          Error(Text002);

        CopyTaxSetup.CopyTaxInfo(SourceCompany,CopyTable);
    end;

    local procedure AllCopyModeOnValidate()
    begin
        AllCopyModeOnPush;
    end;

    local procedure CustomCopyModeOnValidate()
    begin
        CustomCopyModeOnPush;
    end;
}

