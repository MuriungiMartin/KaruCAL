#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 60011 "ELECT-Get Candidate Ranks"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Pos;UnknownTable60001)
        {
            DataItemTableView = where("Position Approved"=filter(Yes));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(ResRanks;UnknownTable60010)
            {
                DataItemLink = "Election Code"=field("Election Code"),"Position Code"=field("Position Code");
                DataItemTableView = sorting("Election Code","Position Code","Votes Count") order(descending);
                column(ReportForNavId_1000000001; 1000000001)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if Scorez=ResRanks."Votes Count" then begin
                        if PositionRank=0 then begin
                          PositionRank:=1;
                          end    else begin
                            PositionRank:=PositionRank;

                        end;
                      end else begin
                      if PositionRank=0 then begin PositionRank:=1;
                        Scorez:=ResRanks."Votes Count"
                        end else begin
                          PositionRank:=PositionRank+1;
                        Scorez:=ResRanks."Votes Count"
                          end;
                        end;

                    ResRanks.Ranking:=PositionRank;
                    if PositionRank=1 then begin
                      ResRanks.Winner:=true;
                      end else begin
                      ResRanks.Winner:=false;
                      end;

                    ELECTPositions.Reset;
                    ELECTPositions.SetRange("Election Code",ResRanks."Election Code");
                    ELECTPositions.SetRange("Position Code",ResRanks."Position Code");
                    if ELECTPositions.Find('-') then begin
                      ELECTPositions.CalcFields("Votes Cast");
                      if ELECTPositions."Votes Cast"<>0 then
                      ResRanks."% Votes":=(Scorez/ELECTPositions."Votes Cast")*100
                      else ResRanks."% Votes":=0;
                      end;

                    ResRanks.Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(PositionRank);
                Clear(Scorez);
                //PositionRank:=1;
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
        ELECTResultsRankings: Record UnknownRecord60010;
        PositionRank: Integer;
        Scorez: Integer;
        ELECTPositions: Record UnknownRecord60001;
}

