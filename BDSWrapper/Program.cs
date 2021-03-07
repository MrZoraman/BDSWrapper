// Copyright (c) 2021 MrZoraman
//
// This software is provided 'as-is', without any express or implied
// warranty. In no event will the authors be held liable for any damages
// arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it
// freely, subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented; you must not
//    claim that you wrote the original software. If you use this software
//    in a product, an acknowledgment in the product documentation would be
//    appreciated but is not required.
// 2. Altered source versions must be plainly marked as such, and must not be
//    misrepresented as being the original software.
// 3. This notice may not be removed or altered from any source distribution.

using System.Threading;

namespace BDSWrapper
{
    using System;
    using System.Collections.Concurrent;
    using System.Diagnostics;
    using System.IO;
    using System.Threading.Tasks;
    using Serilog;

    /// <summary>
    ///     Contains the entry point for the program.
    /// </summary>
    internal class Program
    {
        private static async Task Main(string[] args)
        {
            Log.Logger = new LoggerConfiguration()
                .WriteTo.Console()
                .MinimumLevel.Debug()
                .CreateLogger();

            var consoleInputReader = new ThreadedStreamReader(Console.In, "Console input reader");
            consoleInputReader.Start();
            using var process = new BDSProcess(consoleInputReader);

            await process.StartAsync();

            // using var process = new Process
            // {
            //     StartInfo =
            //     {
            //         FileName = "bds\\bedrock_server.exe",
            //         RedirectStandardOutput = true,
            //         RedirectStandardInput = true,
            //     },
            // };
            //
            // Log.Debug("Process allocated.");
            //
            // process.Start();
            // Log.Debug("Process started.");
            //
            // var runTask = process.WaitForExitAsync();
            // var writeTask = WriteStreamToLogAsync(process.StandardOutput);
            // var inputTask = ReadFromConsoleAsync(process, process.StandardInput);
            //
            // Log.Debug("Tasks created. Delaying...");
            //
            // await Task.Delay(TimeSpan.FromSeconds(5));
            // Log.Information("sending stop command.");
            // await process.StandardInput.WriteLineAsync("stop");
            //
            // await Task.WhenAll(runTask, writeTask, inputTask);
        }

        private static async Task ReadFromConsoleAsync(Process process, StreamWriter writer)
        {
            while (!process.HasExited)
            {
                var input = await Console.In.ReadLineAsync();
                await writer.WriteLineAsync(input);
            }
        }

        private static async Task WriteStreamToLogAsync(StreamReader reader)
        {
            while (!reader.EndOfStream)
            {
                var line = await reader.ReadLineAsync();
                Log.Warning(line);
            }
        }
    }
}
