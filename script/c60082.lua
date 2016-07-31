 
--风·休
function c60082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60082.target)
	e1:SetOperation(c60082.activate)
	c:RegisterEffect(e1)
end
function c60082.rfilter(c)
	return bit.band(c:GetReason(),REASON_BATTLE)~=0 and c:IsAbleToRemove()
end
function c60082.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x191) and c:GetLevel()>1
end
function c60082.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and c60082.rfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c60082.rfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingMatchingCard(c60082.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c60082.rfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c60082.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
	local g=Duel.GetMatchingGroup(c60082.filter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+0xff0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
