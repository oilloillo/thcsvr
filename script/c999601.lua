--探宝棒✿NW
--require "expansions/nef/nef"
function c999601.initial_effect(c)
	--pendulum summon
	local argTable = {1}
	Nef.EnablePendulumAttributeSP(c,99,aux.TRUE,argTable,false)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c999601.activate)
	c:RegisterEffect(e1)
end

function c999601.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local ac=Duel.AnnounceCard(tp)

	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,0)
	e1:SetCondition(c999601.condition)
	e1:SetTarget(c999601.target)
	e1:SetLabel(ac)
	e1:SetValue(-1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
	
	c:SetHint(CHINT_CARD,ac)
end

function c999601.condition(e,tp,eg,ep,ev,re,r,rp)
	local count=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if count>3 then count=3 end
	if count==0 then return false end
	local g=Duel.GetDecktopGroup(tp,3)
	return g:IsExists(Card.IsCode, 1, nil, e:GetLabel())
end

function c999601.target(e,c)
    return c==Duel.GetFieldCard(tp,LOCATION_SZONE,6)
end