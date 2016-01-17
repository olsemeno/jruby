/*
 * Copyright (c) 2016 Oracle and/or its affiliates. All rights reserved. This
 * code is released under a tri EPL/GPL/LGPL license. You can use it,
 * redistribute it and/or modify it under the terms of the:
 *
 * Eclipse Public License version 1.0
 * GNU General Public License version 2
 * GNU Lesser General Public License version 2.1
 */
package org.jruby.truffle.nodes.arguments;

import com.oracle.truffle.api.CompilerDirectives;
import com.oracle.truffle.api.frame.VirtualFrame;
import com.oracle.truffle.api.object.DynamicObject;
import com.oracle.truffle.api.source.SourceSection;
import com.oracle.truffle.api.utilities.ConditionProfile;
import org.jruby.truffle.nodes.RubyGuards;
import org.jruby.truffle.nodes.RubyNode;
import org.jruby.truffle.runtime.RubyArguments;
import org.jruby.truffle.runtime.RubyContext;

public class ReadUserKeywordsHashNode extends RubyNode {

    private final int minArgumentCount;

    public ReadUserKeywordsHashNode(RubyContext context, SourceSection sourceSection, int minArgumentCount) {
        super(context, sourceSection);
        this.minArgumentCount = minArgumentCount;
    }

    @Override
    public Object execute(VirtualFrame frame) {
        final int argumentCount = RubyArguments.getUserArgumentsCount(frame.getArguments());

        if (argumentCount <= minArgumentCount) {
            return null;
        }

        final Object lastArgument = RubyArguments.getUserArgument(frame.getArguments(), argumentCount - 1);

        if (RubyGuards.isRubyHash(lastArgument)) {
            return lastArgument;
        }

        CompilerDirectives.transferToInterpreter();

        if ((boolean) ruby(frame, "last_arg.respond_to?(:to_hash)", "last_arg", lastArgument)) {
            final Object converted = ruby(frame, "last_arg.to_hash", "last_arg", lastArgument);

            if (RubyGuards.isRubyHash(converted)) {
                RubyArguments.setUserArgument(frame.getArguments(), argumentCount - 1, converted);
                return converted;
            }
        }

        return null;
    }

}
