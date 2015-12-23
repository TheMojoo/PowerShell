Describe "New-TimeSpan" {
    It "Should be able to create a new timespan object" {
        New-Variable -Name testObject -Value $(New-TimeSpan)

        $testObject.GetType() | Should Be timespan
    }

    Context "Core Functionality Tests" {
        New-Variable -Name testObject -Value $(New-TimeSpan -Days 2 -Hours 23 -Minutes 4 -Seconds 3) -Force

            $expectedOutput = @{ "Days"              = "2";
                                 "Hours"             = "23";
                                 "Minutes"           = "4";
                                 "Seconds"           = "3";
                                 "Milliseconds"      = "0";
                                 "Ticks"             = "2558430000000";
                                 "TotalDays"         = "2.96114583333333";
                                 "TotalHours"        = "71.0675";
                                 "TotalMinutes"      = "4264.05";
                                 "TotalSeconds"      = "255843";
                                 "TotalMilliseconds" = "255843000"
            }

            $TEN_MILLION = 10000000

        It "Should have expected values for time properties set during creation" {
            $testObject.Days    | Should Be $expectedOutput["Days"]
            $testObject.Hours   | Should Be $expectedOutput["Hours"]
            $testObject.Minutes | Should Be $expectedOutput["Minutes"]
            $testObject.Seconds | Should Be $expectedOutput["Seconds"]
            $testObject.Ticks   | Should Be $expectedOutput["Ticks"]
        }

    }

    It "Should have matching output when using the Start switch vs piping from another cmdlet" {
        # this file is guarenteed to exist
        $inputObject    = (Get-ChildItem $PSScriptRoot/New-TimeSpan.Tests.ps1)
        $inputParameter = New-TimeSpan -Start $inputObject.lastwritetime
        $pipedInput     = $inputObject | New-TimeSpan

        $difference = [math]::Abs($inputParameter.Milliseconds - $pipedInput.Milliseconds)
        # The difference between commands should be minimal
        $difference | Should BeLessThan 10
    }
}