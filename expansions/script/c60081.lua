 
--焰·休
function c60081.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60081.target)
	e1:SetOperation(c60081.activate)
	c:RegisterEffect(e1)
end
function c60081.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x191) and c:GetLevel()>=1
end
function c60081.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60081.filter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c60081.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60081.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-1)
		e1:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
