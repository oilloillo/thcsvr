 
--✿骚灵三姐妹✿
function c20112.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,20018,20020,20022,true,true)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c20112.spcon)
	e1:SetOperation(c20112.spop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20112,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c20112.target)
	e2:SetOperation(c20112.operation)
	c:RegisterEffect(e2)
end
function c20112.spfilter(c,code)
	return c:IsFaceup() and c:GetCode()==code and c:IsAbleToRemoveAsCost() 
end
function c20112.spcon(e,c)
	if c==nil then return true end 
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-4
		and Duel.IsExistingMatchingCard(c20112.spfilter,tp,LOCATION_ONFIELD,0,1,nil,20018)
		and Duel.IsExistingMatchingCard(c20112.spfilter,tp,LOCATION_ONFIELD,0,1,nil,20020)
		and Duel.IsExistingMatchingCard(c20112.spfilter,tp,LOCATION_ONFIELD,0,1,nil,20022)
end
function c20112.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c20112.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,20018)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c20112.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,20020)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c20112.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,20022)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c20112.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c20112.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp)
		and c20112.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20112.filter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20112.filter,tp,LOCATION_REMOVED,0,1,1,nil)
	e:GetHandler():RegisterFlagEffect(20112,RESET_EVENT+0xff0000,0,0)
	local flag=e:GetHandler():GetFlagEffect(20112)
	if flag==3 then
		e:SetCategory(CATEGORY_DESTROY)
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
	else
		e:SetCategory(CATEGORY_TOHAND)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	end
end
function c20112.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	local g1=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	g:Merge(g1)
	local flag=e:GetHandler():GetFlagEffect(20112)
	if flag==3 then
		local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		Duel.Destroy(sg,REASON_EFFECT)
		e:GetHandler():ResetFlagEffect(20112)
	else
		if g:GetCount()>0 then
			--[[local tg=g:GetMinGroup(Card.GetAttack)
			local xg=tg:Select(tp,1,1,nil)
			local hg=xg:GetFirst()
			g:RemoveCard(hg)]]
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			--[[if g:GetCount()>0 then
				Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
			end]]
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			e2:SetValue(500)
			e:GetHandler():RegisterEffect(e2)
		end
	end
end
		