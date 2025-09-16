#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7151 ItemAViewEntryToValueEntries
{

    trigger OnRun()
    begin
    end;

    var
        ItemAnalysisView: Record "Item Analysis View";
        GLSetup: Record "General Ledger Setup";
        DimSetEntry: Record "Dimension Set Entry";


    procedure GetValueEntries(var ItemAnalysisViewEntry: Record "Item Analysis View Entry";var TempValueEntry: Record "Value Entry")
    var
        ValueEntry: Record "Value Entry";
        ItemAnalysisViewFilter: Record "Item Analysis View Filter";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        StartDate: Date;
        EndDate: Date;
        GlobalDimValue: Code[20];
    begin
        ItemAnalysisView.Get(
          ItemAnalysisViewEntry."Analysis Area",
          ItemAnalysisViewEntry."Analysis View Code");

        if ItemAnalysisView."Date Compression" = ItemAnalysisView."date compression"::None then begin
          if ValueEntry.Get(ItemAnalysisViewEntry."Entry No.") then begin
            TempValueEntry := ValueEntry;
            TempValueEntry.Insert;
          end;
          exit;
        end;

        GLSetup.Get;

        StartDate := ItemAnalysisViewEntry."Posting Date";
        EndDate := StartDate;

        with ItemAnalysisView do
          if StartDate < "Starting Date" then
            StartDate := 0D
          else
            if (ItemAnalysisViewEntry."Posting Date" = NormalDate(ItemAnalysisViewEntry."Posting Date")) and
               not ("Date Compression" in ["date compression"::None,"date compression"::Day])
            then
              case "Date Compression" of
                "date compression"::Week:
                  EndDate := ItemAnalysisViewEntry."Posting Date" + 6;
                "date compression"::Month:
                  EndDate := CalcDate('<+1M-1D>',ItemAnalysisViewEntry."Posting Date");
                "date compression"::Quarter:
                  EndDate := CalcDate('<+3M-1D>',ItemAnalysisViewEntry."Posting Date");
                "date compression"::Year:
                  EndDate := CalcDate('<+1Y-1D>',ItemAnalysisViewEntry."Posting Date");
              end;

        with ValueEntry do begin
          SetCurrentkey("Item No.","Posting Date");
          SetRange("Item No.",ItemAnalysisViewEntry."Item No.");
          SetRange("Posting Date",StartDate,EndDate);
          SetRange("Entry No.",0,ItemAnalysisView."Last Entry No.");

          if GetGlobalDimValue(GLSetup."Global Dimension 1 Code",ItemAnalysisViewEntry,GlobalDimValue) then
            SetRange("Global Dimension 1 Code",GlobalDimValue)
          else
            if ItemAnalysisViewFilter.Get(
                 ItemAnalysisView."Analysis Area",
                 ItemAnalysisViewEntry."Analysis View Code",
                 GLSetup."Global Dimension 1 Code")
            then
              SetFilter("Global Dimension 1 Code",ItemAnalysisViewFilter."Dimension Value Filter");

          if GetGlobalDimValue(GLSetup."Global Dimension 2 Code",ItemAnalysisViewEntry,GlobalDimValue) then
            SetRange("Global Dimension 2 Code",GlobalDimValue)
          else
            if ItemAnalysisViewFilter.Get(
                 ItemAnalysisView."Analysis Area",
                 ItemAnalysisViewEntry."Analysis View Code",
                 GLSetup."Global Dimension 2 Code")
            then
              SetFilter("Global Dimension 2 Code",ItemAnalysisViewFilter."Dimension Value Filter");

          if Find('-') then
            repeat
              if DimEntryOK("Dimension Set ID",ItemAnalysisView."Dimension 1 Code",ItemAnalysisViewEntry."Dimension 1 Value Code") and
                 DimEntryOK("Dimension Set ID",ItemAnalysisView."Dimension 2 Code",ItemAnalysisViewEntry."Dimension 2 Value Code") and
                 DimEntryOK("Dimension Set ID",ItemAnalysisView."Dimension 3 Code",ItemAnalysisViewEntry."Dimension 3 Value Code") and
                 UpdateItemAnalysisView.DimSetIDInFilter("Dimension Set ID",ItemAnalysisView)
              then
                if ((ItemAnalysisView."Analysis Area" = ItemAnalysisView."analysis area"::Sales) and
                    ("Item Ledger Entry Type" = "item ledger entry type"::Sale) and
                    ("Entry Type" <> "entry type"::Revaluation)) or
                   ((ItemAnalysisView."Analysis Area" = ItemAnalysisView."analysis area"::Purchase) and
                    ("Item Ledger Entry Type" = "item ledger entry type"::Purchase)) or
                   ((ItemAnalysisView."Analysis Area" = ItemAnalysisView."analysis area"::Inventory) and
                    ("Item Ledger Entry Type" <> "item ledger entry type"::" "))
                then
                  if not TempValueEntry.Get("Entry No.") then begin
                    TempValueEntry := ValueEntry;
                    TempValueEntry.Insert;
                  end;
            until Next = 0;
        end;
    end;

    local procedure DimEntryOK(DimSetID: Integer;Dim: Code[20];DimValue: Code[20]): Boolean
    begin
        if Dim = '' then
          exit(true);

        if DimSetEntry.Get(DimSetID,Dim) then
          exit(DimSetEntry."Dimension Value Code" = DimValue);

        exit(DimValue = '');
    end;

    local procedure GetGlobalDimValue(GlobalDim: Code[20];var ItemAnalysisViewEntry: Record "Item Analysis View Entry";var GlobalDimValue: Code[20]): Boolean
    var
        IsGlobalDim: Boolean;
    begin
        case GlobalDim of
          ItemAnalysisView."Dimension 1 Code":
            begin
              IsGlobalDim := true;
              GlobalDimValue := ItemAnalysisViewEntry."Dimension 1 Value Code";
            end;
          ItemAnalysisView."Dimension 2 Code":
            begin
              IsGlobalDim := true;
              GlobalDimValue := ItemAnalysisViewEntry."Dimension 2 Value Code";
            end;
          ItemAnalysisView."Dimension 3 Code":
            begin
              IsGlobalDim := true;
              GlobalDimValue := ItemAnalysisViewEntry."Dimension 3 Value Code";
            end;
        end;
        exit(IsGlobalDim);
    end;
}

