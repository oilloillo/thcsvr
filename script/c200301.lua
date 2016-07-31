 
--天启气象之剑
function c200301.initial_effect(c)
	--field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200301,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c200301.target)
	e1:SetOperation(c200301.activate)
	c:RegisterEffect(e1)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(200301,2))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c200301.tg2)
	e1:SetOperation(c200301.op2)
	c:RegisterEffect(e1)
end
function c200301.filter(x)
	return x>=200101 and x<=200120
end
function c200301.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,0)
	local ac=Duel.AnnounceCard(tp)
	local t=1
	while not c200301.filter(ac) and t<5 do
	Duel.SelectOption(tp,aux.Stringid(200301,1))
	Duel.Hint(HINT_SELECTMSG,tp,0)
	ac=Duel.AnnounceCard(tp)
	if ac>=200501 and ac<=200520 then ac=ac-400 end
	t=t+1
	end
	if not c200301.filter(ac) and t==5 then ac=math.random(200101,200120) end
	e:SetLabel(ac)
end
function c200301.activate(e,tp,eg,ep,ev,re,r,rp)
	local token=Duel.CreateToken(tp,e:GetLabel())
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
--	Duel.RaiseEvent(token,EVENT_CHAIN_SOLVED,token:GetActivateEffect(),0,tp,tp,Duel.GetCurrentChain())
end
function c200301.filter2(c)
	return c:IsSetCard(0x701) and c:IsFaceup() and c:IsAbleToRemove()
end
function c200301.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c200301.filter2(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
	and Duel.IsExistingTarget(c200301.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c200301.filter2,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c200301.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then Duel.Draw(tp,1,REASON_EFFECT) end
	end
end