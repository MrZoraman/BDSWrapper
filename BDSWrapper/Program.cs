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

using System.Runtime.Loader;
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
    internal class Program : IDisposable
    {
        private readonly BDSProcess _process;

        private Program(ThreadedStreamReader consoleInputReader)
        {
            _process = new BDSProcess(consoleInputReader);
            AppDomain.CurrentDomain.ProcessExit += OnExit;
        }

        private static async Task Main(string[] args)
        {
            Log.Logger = new LoggerConfiguration()
                .WriteTo.Console()
                .MinimumLevel.Debug()
                .CreateLogger();

            Console.CancelKeyPress += (sender, eventArgs) =>
            {
                eventArgs.Cancel = true;
            };

            var consoleInputReader = new ThreadedStreamReader(Console.In, "Console input reader");
            consoleInputReader.Start();
            using var program = new Program(consoleInputReader);
            await program.RunAsync();
        }

        private void OnExit(object? sender, EventArgs e)
        {
            _process.RequestStop();
        }

        private Task RunAsync()
        {
            return _process.RunAsync();
        }

        public void Dispose()
        {
            AppDomain.CurrentDomain.ProcessExit -= OnExit;
            _process.Dispose();
        }
    }
}
